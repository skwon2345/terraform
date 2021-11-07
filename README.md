# Terraform
This is practice of terraform.

## pre-req
There are few pre-requsite programs to install.
- keybase
- jq

### keybase
```shell
$ brew install —cask keybase
```
Then you will see keybase App. After signing up for keybase, execute the following command to generate pgp. `pgp` is used to decrypt an encrypted password from aws iam user.
```shell
$ keybase pgp gen
```

### jq
```shell
$ brew install jq
```

## commands
### init
Execute the following command inside the folder where terraform files reside.
```shell
$ terraform init
```

### validation (basic grammer check)
For validating your terraform code, execute the following command.
```shell
$ terraform validate
```

### plan
You preview the result of your terraform code by executing the following command.
```shell
$ terraform plan
```

### apply
Apply your terraform code by executing the command below.
```shell
$ terraform apply
```
options:
- `-auto-approve`: skip confirming question before creating infrastructure.
- `-refresh-only`: apply small changes that do not affect your infrastructure. ex) output
- `-replace`: you can replace any changes on any blocks in your terraform code with this option.
- `-destroy`: destroy your infrastructure.

### output
You can get output values defined in output block by executing the command below.
```shell
$ terraform output
```
options:
- `-raw`: return output value without ""

### importing iam user group
You can import an existing iam user group by executing the following code.
```shell
$ terraform import aws_iam_group.group <exisiting-user-group>
``` 
By executing the code above, `terraform.tfstate` will hold arn of user group you've imported. So any changes on your user group, such as attaching a new policty will be reflected automatically.

If you want to replace your user group with the same block name, you can execute the following code to remove imported user group.
```shell
$ terraform state list
$ terraform state rm aws_iam_group.group <imported-user-group>
``` 

### decrypt iam user password
```shell
$ terraform output -json password | base64 --decode | keybase pgp decrypt
```
If the type of your password output is map, use the code below.
```shell
$ terraform output -json password | jq -r '.["<key>"]' | base64 --decode | keybase pgp decrypt
```