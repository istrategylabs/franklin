# Core Fabric imports
from fabric.api import env, require, run, task, local, roles
from fabric.contrib.project import rsync_project
from fabric.utils import abort

# Third-party app imports
import unipath


PROJECT_DIR = unipath.Path(__file__).ancestor(2)
GIT_ORIGIN = 'git@github.com'


#
# Pulling
#

@task
@roles('static')
def pull():
    """ git pull on all the repositories """
    require('roledefs', provided_by=['staging'])
    run("cd %(base)s; git pull %(remote)s %(branch)s; git fetch;" % env)

@task
@roles('static')
def restart_service():
    """ Restarts the open resty service """
    require('roledefs', provided_by=['staging'])
    run("restart-resty")


@task
@roles('static')
def deploy():
    """ Deploys static """
    require('roledefs', provided_by=['staging'])
    pull()
    restart_service()

@task
def production():
    """ use production settings """
    env.environment = 'staging'
    env.repo = ('origin', 'master')
    env.remote, env.branch = env.repo
    env.base = '/var/nginx/conf'
    env.user = 'ubuntu'
    env.roledefs = {
        'static': ['52.4.163.61']
    }
    env.dev_mode = False
