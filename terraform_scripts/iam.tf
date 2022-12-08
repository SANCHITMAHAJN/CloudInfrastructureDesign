# Create HR Group
resource "aws_iam_group" "hr" {
  name = "HR"
  path = "/users/"
}

#Full IAM access policy for the HR group
data "aws_iam_policy" "iampolicy" {
  arn = "arn:aws:iam::aws:policy/IAMFullAccess"
}

#Attach policy
resource "aws_iam_group_policy_attachment" "iampolicyattach" {

  
  group       = "${aws_iam_group.hr.name}"
  policy_arn = "${data.aws_iam_policy.iampolicy.arn}"
}


# Create Finance Group
resource "aws_iam_group" "finance" {
  name = "Finance"
  path = "/users/"
}

#Full Budgets access policy for the Finance group
data "aws_iam_policy" "budgetspolicy" {
  arn = "arn:aws:iam::aws:policy/AWSBudgetsActionsWithAWSResourceControlAccess"
}

#Attach policy
resource "aws_iam_group_policy_attachment" "budgetspolicyattachfinance" {

  
  group       = "${aws_iam_group.finance.name}"
  policy_arn = "${data.aws_iam_policy.budgetspolicy.arn}"
}



# Create IT Group
resource "aws_iam_group" "it" {
  name = "IT"
  path = "/users/"
}

#Network Admin access policy for the IT group
data "aws_iam_policy" "networkadminpolicy" {
  arn = "arn:aws:iam::aws:policy/job-function/NetworkAdministrator"
}

#Attach policy
resource "aws_iam_group_policy_attachment" "networkadminpolicyattach" {

  
  group       = "${aws_iam_group.it.name}"
  policy_arn = "${data.aws_iam_policy.networkadminpolicy.arn}"
}


# Create Executive Group
resource "aws_iam_group" "exec" {
  name = "Executive"
  path = "/users/"
}

# Give access to budgets
resource "aws_iam_group_policy_attachment" "budgetspolicyattachexec" {
  group       = "${aws_iam_group.exec.name}"
  policy_arn = "${data.aws_iam_policy.budgetspolicy.arn}"
}
