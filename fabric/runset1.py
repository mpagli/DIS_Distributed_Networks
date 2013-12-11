from fabric.api import *
from multiprocessing import Lock, Queue
env.dedupe_hosts = False

valid_hosts_ids = list(range(1,30))
valid_hosts_ids = [1,2,4,5,6,7,8,9,10,11,12,13,14,15,16,18,19,20,21,22,25,26,27,28]

valid_hosts = ['fasnacht@smapc{0:03d}.epfl.ch'.format(x) for x in valid_hosts_ids]

env.roledefs = {
    'deploy': valid_hosts,
    'run': valid_hosts*4,
} 

jobs = [(x,x+1,y) for x in range(1,100,2) for y in [3, 5, 7, 9, 11, 13, 15, 17, 19]]

env.work_queue = Queue()
env.work_queue.put(jobs)
env.DUP_LOCKER = Lock()

def get_unique_index():
    env.DUP_LOCKER.acquire()
    result = env.UNIQUE_ID.value
    env.UNIQUE_ID.value = result + 1
    env.DUP_LOCKER.release()
    return result

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
    assert len(env.all_hosts)>=len(jobs),"We need %d hosts (%d provided)"%(len(jobs),len(env.all_hosts))
    run('uname -a')
    #print env
    
@task
def RunSet1():
    jobs=env.jobs
    #jobs=[(1,2,3)]
    
    run('mkdir -p /home/fasnacht/set1')
    
    while True:
        job = env.work_queue.get_nowait()
        jobdescfile = '/home/fasnacht/set1/.{0}'.format('-'.join(job))
        try:
            get(jobdescfile)
            continue
        except:
            pass
        
        with cd('/tmp/dis-project/Code'):
            run('OUTDIR=/home/fasnacht/set1 IMIN={0[0]} IMAX={0[1]} K={0[2]} nice matlab -nodisplay -r "runset1; quit;"'.format(jobs[idx]))
    
        run('touch {0}'.format(jobdescfile))

if __name__ == '__main__':
    import sys
    from fabric.main import main
    sys.argv = ['fab', '-f', __file__,] + sys.argv[1:]
    main()

