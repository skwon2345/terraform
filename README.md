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

### Use your own pgp_key instead of using keybase
If you want to use your custom pgp key, without usingn keybase app, try the following command.
```shell
$ brew install gpg
```

```shell
$ gpg --full-generate-key
```
You will see the selection below, after execute the command above.
```shell
Please select what kind of key you want:
   (1) RSA and RSA
   (2) DSA and Elgamal
   (3) DSA (sign only)
   (4) RSA (sign only)
   (9) ECC (sign and encrypt) *default*
  (10) ECC (sign only)
  (14) Existing key from card
```
Choose (1) RSA and RSA.
Then you will select the size of your key. Type 4096.
```shell
RSA keys may be between 1024 and 4096 bits long.
What keysize do you want? (3072) 4096
```
After answering the several more questions, you will succeed to create your first pgp key. Check if you have one by executing the following command.
```shell
$ gpg --list-keys
```
Then encode your pgp key with base64
```shell
$ gpg --export <key-name> | base64 > public_key_file
```
In my case, I used my real name to create key, so it will be like the following.
```shell
$ gpg --export "Sukkwon On" | base64 > public_key_file
```
Move `public_key_file` to the terraform directory.
```shell
$ mv public_key_file <path_to_terraform_dir>
```
Make sure your `GPG_TTY` is set to `tty`. Execute the following command to make gpg clear where to read files.
```shell
$ export GPG_TTY=$(tty)
```

You are all done for pgp key settings. Now, on your `main.tf`, set `pgp_key` to `public_key_file`

```python
resource "aws_iam_user_login_profile" "u" {
  for_each = aws_iam_user.hits_users
  user    = each.value.name
  pgp_key = file("public_key_file")
}
```

You are all done for using your own pgp key for aws iam users' password encryption!
