# CloudInfrastructureDesign
This project gets user requirements via Google Form and automatically creates infrastructure in AWS based on the responses using Python, Jenkins, and Terraform.


<img width="408" alt="image" src="https://user-images.githubusercontent.com/108757980/208768915-732f0beb-25dc-4835-be9b-afa185940708.png">



**How does it Work?**
 
 Our client sends us their access keys via email and we put them in our terraform script provider.tf. This can be changed for each client using CI.
 
 Step 1 - We send a Google form to our client asking if they want to create some basic features in their AWS Account. It should look something like this:
 
 
<img width="249" alt="image" src="https://user-images.githubusercontent.com/108757980/206533575-3b587976-abcc-41a3-b5fa-b3473242907d.png">
<img width="294" alt="image" src="https://user-images.githubusercontent.com/108757980/206533738-1f38ec32-6d2e-4a3b-9b95-f31a7e099b61.png">

  Step 2 - The client fills in the simple form, and the user results get into our Python Script through Google Forms API.
  Step 3 - We have the already created Terraform script for each option uploaded to our private GitHub repo, and can be automatically applied using Jenkins.
  Step 4 - We have a paramaterized Jenkins pipeline created for each Terraform script that can apply/destroy the configurations.
  Step 5 - We create IF scripts in Python  to run Jenkins builds based on answers for each QuestionID (fetched by Google API results)
  Step 6 - Using **jenkins** library in python, we run the command server.build_job to build those specific jobs in AWS
  Step 7 - After a minute, the infrastructure gets set up in AWS!
  Step 8 - We have also configured the user to get email automatically on the account they mentioned in Google Forms with all the relevant information.The email looks like this:
  
  <img width="520" alt="image" src="https://user-images.githubusercontent.com/108757980/206535103-1ef47d5f-19a4-42e6-9426-59798440f372.png">



  
**How to do it?**

Step 1 - Create the Google Form and note down the FormID (on the url bar) and QuestionIDs for each question (use gformfetch.py to extract the result you said Yes to)

 Step 2 - Use the python code mentioned, and replace the following values:
           Google Form ID
           QuestionIDs
           Jenkins username and password
           sender/receiver email address
           
Step 3 - Create Terraform scripts and modify it according to your needs. Add your access keys in provider.tf and upload them to GitHub.

Step 4 - Create a Jenkins pipeline (uploaded here) for each feature like VPC, adminacc, etc.

Step 5 - Test the working!



**Libraries/Extensions Needed**

For Python - 
from __future__ import print_function
from apiclient import discovery
from httplib2 import Http
from oauth2client import client, file, tools
import jenkins
from email.message import EmailMessage
import ssl
import smtplib


For Jenkins:
Terraform Plugin


For any queries, please message me on LinkedIn : https://www.linkedin.com/in/sanchitmahajan28/
