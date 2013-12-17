from fabric.api import *
from fabric.contrib.files import exists
from multiprocessing import Lock, Queue
from Queue import Empty
env.dedupe_hosts = False

valid_hosts_ids = list(range(1,30))
#valid_hosts_ids = [1,2,4,5,6,9,10,11,12,13,14,15,16,17,19,20,21,22,23,24,28]
valid_hosts_ids.remove(26)

valid_hosts = ['fasnacht@smapc{0:03d}.epfl.ch'.format(x) for x in valid_hosts_ids]

env.roledefs = {
    'deploy': valid_hosts,
    'run': valid_hosts*4,
} 

jobs = [(x,x+1,y) for y in [0.1, 0.2, 0.3, 0.4, 0.5] for x in range(1,100,2)]

env.work_queue = Queue()
for j in jobs:
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
def RunSet2():
    #jobs=[(1,2,3)]
    
    run('mkdir -p /home/fasnacht/set2')
    
    try:
        while True:
            job = env.work_queue.get_nowait()
            jobdescfile = '/home/fasnacht/set2/.' + '-'.join([str(x) for x in job])
            if exists(jobdescfile):
                continue
            
            with cd('/tmp/dis-project/Code'):
                run('OUTDIR=/home/fasnacht/set2 IMIN={0[0]} IMAX={0[1]} F={0[2]} nice matlab -nodisplay -r "runset2; quit;"'.format(job))
        
            run('touch {0}'.format(jobdescfile))
    except Empty:
        pass

if __name__ == '__main__':
    import sys
    from fabric.main import main
    sys.argv = ['fab', '-f', __file__,] + sys.argv[1:]
    main()

