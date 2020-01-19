Devops pipeline app

brief:
This project is intended to create a pipeline for a Python app. The app is
intended to request information from ITJobsWatch. I was tasked to create a virtual
machine in vagrant, which is provisioned with chef_solo, the project would then
be uploaded to github on the developer branch, where it is sent to jenkins to be tested
and then merged with the master branch. The project would then be sent to packer,
where an AMI is created and sent to AWS.

python app:
the app files are contained within the 'Python_app' folder. To run the program on
git for windows, I went into the app directory and ran 'python main.py' which runs
a program which is controlled with a command line interface (and 1 and 2 commands).
when the program is made to make a request to the website, it gathers data and
writes into a csv file 'ItJobsWatchTop30.csv' in a Downloads folder.

Vagrant virtual machine:
To run this app in a Virtual Machine, I used vagrant to create a local VM. The
vagrant file for this process is found in this project folder (Vagrantfile).
we have synced the Python_app folder so that we can access the files inside the
VM. I needed to perform some required installations on the virtual machine before
running the app. The first was to install the Python 3 versions of the developer kit
and pip (pip is the package installer for python packages). I then needed to install
the required packages as specified in the requirements file (requirements.txt),
this was done using the pip installer. I then needed to create the Downloads directory
and ItJobsWatchTop30.csv so that the data from the request can be written. To run
the program inside the program I typed 'python3 main.py' inside the app folder.
the commands to reach this step are detailed in the provision.sh file (this is a
provision script for Vagrant before I translated it into a chef cookbook).

Chef Cookbook:
I then began working on creating the cookbook for the VM. this cookbook and all
the files can be found in https://github.com/jfarmer864/Python_cookbook. To correctly provision our
machine, I needed to create a recipe (chef's version of a provision script) that
replicated the steps I did before to get a working app. The recipe is written in
ruby which is a more accessible language so this task wasn't too difficult. chef
also has the added benefit of allowing the cookbook to be tested with unit and
integration tests. unit tests can be run by typing 'chef exec rspec' in the cookbook
folder, which will run the tests scripts in the spec/unit/recipes folder. integration
tests can be run with 'kitchen verify', this command runs a specific process:
- it creates the ubuntu virtual Machine
- it converges (runs any initial provisions)
- it sets up by installing dependencies
- it finally runs the integration test (located in test/integration/default)
once these tests complete with no fails, it can be sent to Jenkins

Jenkins and Github:
Jenkins is an automation server based in the cloud which is used to run testing
and merging or projects. Github is a website that stores repositories and can
communicate with jenkins to manage pipelines and make a continuous development
process. The project is uploaded onto github at this repository:
https://github.com/jfarmer864/Packer_chef_dev_production
This repo has a webhook which is configured to activate when a developer pushes
to this repository. On Sparta's Jenkins server there is a job called
'jack-farmer-eng47-python-app-test' which will perform application tests in the
app under tests/ and if successful the job will then merge the developer and
master branches for the repository on Github. If this Jenkins job is completed
successfully, then a second Jenkins Job will initiate which will call packer to
build an AMI with the updated project.

Jenkins also has a job specifically with the Python_cookbook, this is similar to
the job above where it will perform the Unit and integration tests for the cookbook
as described above and if successful, will merge together the developer and master
branches.

Unfortunately, there was a problem with running the tests in Jenkins as the server
had problems with using the python and chef slave nodes, these are needed to perform
the python based tests for the application and the chef tests for the cookbook.
as a result the repository branches are merged manually for the time being.

Jenkins Cookbook pipeline:
1. upload to Github Cookbook developer branch
2. trigger Jenkins cookbook test Job with webhook
3. perform unit and integration tests with chef slave node
4. if successful, initiate merging with master branch

Jenkins Python application test:
1. upload to Github application developer branch
2. trigger Jenkins app test job with webhook
3. run pytest program on python slave node to test application
4. if successful, initiate merge with master branch and trigger packer Job
5. Packer job starts by calling berks command to grab latest cookbook build from Github
6. Packer job then calls build command in packer to create AMI of project which will
then appear on AWS

Packer:
Packer is a program that helps configure the creation of machine images. I was tasked
to create an AMI (Amazon Machine Image) with the VM and cookbook created on my local
machine. The Packer program uses the 'python_packer.json' file to specify how the
AMI is created. To access AWS to create the images, we needed to have security keys
specified in the packer. fortunately Packer allows users to specify environment
variables of the keys outside of the file, hence why they are not included in this
project folder! The Packer program uses the amazon-ebs to create the Amazon versions
of the machine image which is specified in the JSON file. the file also details
a provisioner which in this case is chef-solo.

An AMI was created to be used as a python slave node, this AMI was configured to
have Python3, Pip and the app requirements already installed but not the app itself
included in the VM. This AMI is called python_app_jack_farmer-jfarmer864-slave-1.1
- ami-058430672cd23bf65 and is visible on AWS

Berksfile:
Just a note on the Berksfile, I had to do the chef tests locally in a different location
and when I was satisfied with the cookbook, I used the command 'berks vendor Cookbooks'
which moved the cookbook from that location to this project folder. This is also
useful in Jenkins as it allows developer and environment pipeline to remain seperate,
only having the two pipelines come together when the AMI is built, this ensures that
development is more flexible and isn't tied down by another team's issues.

Things that worked:
- local python_app VM with shell script provision
- python app chef cookbook and unit/integration tests
- local python_app VM with chef provision
- Packer AMI for a base Ubuntu machine
- Packer creating AMI with full provisioning

Things that had issues:
- Jenkins running unit/integration tests and github merging

things that can be improved:
- Jenkins issues came form the fact that the slave node for Python and Chef
were not up and running due to technical issues out of my control. So although
the jobs exist on the server, it was not possible to check if they worked correctly.
