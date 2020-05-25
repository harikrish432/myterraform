resource "aws_subnet" "public_subnet" {
  count                   = "${length(slice(local.mydata, 0, 2))}"
  vpc_id                  = "${aws_vpc.prod_vpc.id}"
  cidr_block              = "${cidrsubnet(var.myvpc_cidr, 8, count.index + length(local.mydata))}"
  availability_zone       = "${local.mydata[count.index]}"
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet -${count.index + 1}"
  }
}

resource "aws_internet_gateway" "igw-public" {
  vpc_id = "${aws_vpc.prod_vpc.id}"
}

resource "aws_route_table" "rt-public" {
  vpc_id = "${aws_vpc.prod_vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw-public.id}"
  }

  tags = {
    Name = "RT-Public"
  }
}

resource "aws_route_table_association" "sub" {
  count          = "${length(slice(local.mydata, 0, 2))}"
  subnet_id      = "${aws_subnet.public_subnet.*.id[count.index]}"
  route_table_id = "${aws_route_table.rt-public.id}"
}
