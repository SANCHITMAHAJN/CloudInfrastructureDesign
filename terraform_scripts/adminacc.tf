
#Create Administrators Group with awsadmin Account
resource "aws_iam_group" "admins" {
  name = "Administrators"
  path = "/users/"
}

#Admin access policy on Admins group
data "aws_iam_policy" "adminpolicy" {
  arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

#Attach policy
resource "aws_iam_group_policy_attachment" "adminpolicyattach" {

  
  group       = "${aws_iam_group.admins.name}"
  policy_arn = "${data.aws_iam_policy.adminpolicy.arn}"
}

#Create admin
resource "aws_iam_user" "awsadmin" {
  name = "awsadmin"
}



resource "aws_iam_user_group_membership" "adminmembership" {
  user = aws_iam_user.awsadmin.name

  groups = [
    aws_iam_group.admins.name
  ]
}