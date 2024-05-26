data "aws_eip" "by_tag1" {
  filter {
    name = "tag:Name"
    values = ["rocket-elastic-ip-1"]
  }
}
data "aws_eip" "by_tag2" {
  filter {
    name = "tag:Name"
    values = ["rocket-elastic-ip-2"]
  }
}