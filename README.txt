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
the files can be found in Cookbooks/python_cookbook. To correctly provision our
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
'jack-farmer-eng47-python-app-test' which is supposed the same unit and integration tests
as before, the job will then merge the developer and master branches for the repository on
Github.

Unfortunately, there was a problem with running the tests in Jenkins as the server
had problems with installing and running chef. Therefore the cloud tests could not be
run. I merged the repo branches manually and I moved onto packer.

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

I was able to create an AMI of a base Ubuntu 16.04 machine, however due to the program
not being able to find the right file locations, I was not able to run the provision
script in Packer.

Berksfile:
Just a note on the Berksfile, I had to do the chef tests locally in a different location
and when I was satisfied with the cookbook, I used the command 'berks vendor Cookbooks'
which moved the cookbook from that location to this project folder.

Things that worked:
- local python_app VM with shell script provision
- python app chef cookbook and unit/integration tests
- local python_app VM with chef provision
- Packer AMI for a base Ubuntu machine

Things that had issues:
- Jenkins running unit/integration tests and github merging
- Packer creating an AMI with full provision

things that can be improved:
- The problem with Packer was based on the program not finding the right location
to send the app files, I could have remedied this by spinning up the base ubuntu
instance and looking at the direct file structure, unfortunately it would have ended
up being expensive to start spinning up instances!
- Jenkins needed to have chef installed on the server, unfortunately there were
many issues and even after the trainer tried to fix this issue, it was not possible
to conduct tests on the Jenkins server.
