from __future__ import print_function
from apiclient import discovery
from httplib2 import Http
from oauth2client import client, file, tools
import jenkins
from email.message import EmailMessage
import ssl
import smtplib

SCOPES = "https://www.googleapis.com/auth/forms.responses.readonly"
DISCOVERY_DOC = "https://forms.googleapis.com/$discovery/rest?version=v1"

store = file.Storage('token.json')
creds = None
if not creds or creds.invalid:
    flow = client.flow_from_clientsecrets('client_secrets.json', SCOPES)
    creds = tools.run_flow(flow, store)
service = discovery.build('forms', 'v1', http=creds.authorize(
    Http()), discoveryServiceUrl=DISCOVERY_DOC, static_discovery=False)

#Form ID: FIll this out
form_id = ''

result = service.forms().responses().list(formId=form_id).execute()

# Set up Jenkins
server = jenkins.Jenkins('http://localhost:8080', username='', password='')


# replace QuestionIDs with your own ones

#Check if the user said YES to creation of admin account
admin_acc = result["responses"][0]["answers"]['QuestionID']['textAnswers']['answers'][0]['value']

#Run admin_acc build on Jenkins if the response was yes
if admin_acc == "Yes":
    server.build_job('admin_acc', {'ACTION': 'apply'})
    print ("Creating Administrator Account called awsadmin, check the results in a minute")


#Check if the user said YES to creation of IAM Groups
iam = result["responses"][0]["answers"]['QuestionID']['textAnswers']['answers'][0]['value']

#Run admin_acc build on Jenkins if the response was yes
if iam == "Yes":
    server.build_job('iam', {'ACTION': 'apply'})
    print ("Creating the following IAM Groups: HR, IT, Finance, Executive. check the results in a minute")



#Check if the user said YES to creation of $20 monthly budget
budget = result["responses"][0]["answers"]['QuestionID']['textAnswers']['answers'][0]['value']

#Run budget build on Jenkins if the response was yes
if budget == "Yes":
    server.build_job('budget', {'ACTION': 'apply'})
    print ("Creating the budget, check the results in a minute")



#Check if the user said YES to creation of S3 bucket
s3 = result["responses"][0]["answers"]['QuestionID']['textAnswers']['answers'][0]['value']
#Run s3 build on Jenkins if the response was yes
if s3 == "Yes":
    server.build_job('s3', {'ACTION': 'apply'})
    print ("Creating the bucket, check the results in a minute")


#Check if the user said YES to creation of Production VPC
vpc = result["responses"][0]["answers"]['QuestionID']['textAnswers']['answers'][0]['value']
#Run vpc build on Jenkins if the response was yes
if vpc == "Yes":
    server.build_job('vpc', {'ACTION': 'apply'})
    print ("Setting up the VPC in us-east-2a, check the results in a minute")


# Check if the user said YES to creation of an EC2 instance
ec2 = result["responses"][0]["answers"]['QuestionID']['textAnswers']['answers'][0]['value']

# Create EC2 instance and VPC if the response was Ubuntu
if ec2 == "Ubuntu":
    server.build_job('ec2_ubuntu', {'ACTION': 'apply'})
    print("Setting up the VPC and Ubuntu Instance in us-east-2a, check the results in a minute")

# Create EC2 instance and VPC if the response was Windows
if ec2 == "Windows":
    server.build_job('ec2_win', {'ACTION': 'apply'})
    print("Setting up the VPC and Windows Instance in us-east-2a, check the results in a minute")

# Create EC2 instance and VPC if the response was Red-Hat
if ec2 == "Red-Hat":
    server.build_job('ec2_red_hat', {'ACTION': 'apply'})
    print("Setting up the VPC and Red-Hat Instance in us-east-2a, check the results in a minute")


# Get webserver response
webserver = result["responses"][0]["answers"]['QuestionID']['textAnswers']['answers'][0]['value']

# Create webserver if the response was Yes
if webserver == "Yes":
    server.build_job('webserver', {'ACTION': 'apply'})
    print("Setting up Ubuntu Webserver, check the results in a minute")

# Send emails
text = "Hello, \n Your Infrastructure has been set up in us-east-2 (Ohio) region. \n \nIf you selected 'Yes' to the following questions:" \
       " \n\nAdmin account called awsadmin (inside the Administrators group) should be set up. You can log in as root to configure its password." \
       " \n \nThe following IAM Groups should be created with the relevant policies added:\n  Executive\n  HR\n  IT\n  Finance\n An S3 bucket " \
       "has been created.\nThe VPC should been created in the subnet 10.0.0.0/16. \nThe EC2 instances should be created and are not publicly " \
       "accessible (no public IPs). \nWebserver should be set up with an Elastic IP that you can check in the console, and the security groups " \
       "allow incoming http(s) and ssh traffic through ports 22,80, and 443. \nThe Budget has been set up for $20 and you" \
       "'ll and an email will be sent out when the forecasted budget reaches 90% of the total budget. \n\nPlease login to your AWS account at" \
       " https://console.aws.amazon.com/ to view the changes.\n \nBest,\nSanchit Mahajan Consulting"

email_receiver = result["responses"][0]["answers"]['QuestionID']['textAnswers']['answers'][0]['value']
email_sender = ''
email_password = '' # Create this in Gmail security settings using App Password

subject = "Infrastructure Setup"
body = text

em = EmailMessage()
em['From'] = email_sender
em['To'] = email_receiver
em['Subject'] = subject
em.set_content(body)

# Install some certificates for security
context = ssl.create_default_context()
with smtplib.SMTP_SSL('smtp.gmail.com', 465, context=context) as smtp:
    smtp.login(email_sender, email_password)
    smtp.sendmail(email_sender, email_receiver, em.as_string())




