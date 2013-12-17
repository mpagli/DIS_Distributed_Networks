from fabric.api import *
from fabric.contrib.files import exists
from multiprocessing import Lock, Queue
from Queue import Empty
import time
env.dedupe_hosts = False

#valid_hosts_ids = list(range(1,30))
valid_hosts_ids = [1,2,4,5,6,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,26,28]

valid_hosts = ['fasnacht@smapc{0:03d}.epfl.ch'.format(x) for x in valid_hosts_ids]

env.roledefs = {
    'deploy': valid_hosts,
    'run': valid_hosts*4,
} 

jobs = [(x,x+10,y,z,w) for w in [0, 0.1, 0.2] for z in [0.5, 1, 1.5, 2, 2.5, 3] for y in [0.1, 0.2, 0.3, 0.4, 0.5] for x in range(1,50,10)]

env.work_queue = Queue()
for j in jobs:
    time.sleep(0.01)
    env.work_queue.put(j)

@task
def Deploy():
    run('git clone https://fasnacht:ox59xTzf@private.o-t.ch:17443/git/dis/project /tmp/dis-project')
    run('chmod 700 /tmp/dis-project')
    
@task
def Update():
    with cd('/tmp/dis-project'):
        run('git pull')
    
@task
def Test():
    run('uname -a')
    #print env
    
@task
def RunSetDMin():
    #jobs=[(1,2,3)]
    
    run('mkdir -p /home/fasnacht/setdmin')
    
    try:
        while True:
            job = env.work_queue.get_nowait()
            jobdescfile = '/home/fasnacht/setdmin/.' + '-'.join([str(x) for x in job])
            if exists(jobdescfile):
                continue
            
            with cd('/tmp/dis-project/Code'):
                run('OUTDIR=/home/fasnacht/setdmin IMIN={0[0]} IMAX={0[1]} NOISE={0[2]} DMIN={0[3]} SR={0[4]} nice matlab -nodisplay -r "runsetdmin; quit;"'.format(job))
        
            run('touch {0}'.format(jobdescfile))
    except Empty:
        pass

if __name__ == '__main__':
    import sys
    from fabric.main import main
    sys.argv = ['fab', '-f', __file__,] + sys.argv[1:]
    main()

