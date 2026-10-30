resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "grocerymate-vpc"
  }
}

resource "aws_subnet" "public_1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "eu-central-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "grocerymate-public-1"
  }
}

resource "aws_subnet" "public_2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "eu-central-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "grocerymate-public-2"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "grocerymate-igw"
  }
}

# Public Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
  tags = {
    Name = "grocerymate-public-rt"
  }
}

# Subnet1 mit Route table verbinden
resource "aws_route_table_association" "public_1" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.public.id
}

# Subnet2 mit Route table verbinden
resource "aws_route_table_association" "public_2" {
  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.public.id
}

/*   
Erste Block:
resource : Terrraform soll eine AWS-Resource verwalten
aws-vpc: Resource Typ: VPC
main: Interner Name innerhalb von Terraform
cidr_block = IP-Adressbereich deiner VPC
enable_dns_support = true bedeutet DNS -Auflösung activieren 
enable_dns_hostnames = true bedeutet DNS-Hostnamen für geeignete Instanzen ermöglicheten
tags = Zusatzliche Information zur Ressource
Name = "grocermate-vpc" bedeutet Name der VPC, Anzeigename in AWS Konsole


Das ist ein privater IP-Adressbereich.
- 10.0.0.0 ist die Netzwerkadresse.
- /16 bedeutet, dass die ersten 16 Bits den Netzwerkanteil bilden.
- Der Bereich umfasst 65.536 IPv4-Adressen.




Zweietr Code Block : erster  Subnet
 vpc_id = aws_vpc.main.id

Damit sagst du Terraform: Dieses Subnet gehört zu der VPC namens main, die wir oben definiert haben.

cidr_block = "10.0.1.0/24"

Dieses Subnet bekommt einen kleineren IP-Bereich mit 256 Adressen. AWS reserviert davon fünf, sodass 251 nutzbar bleiben.

availability_zone = "eu-central-1a"

Das Subnet wird in einer Availability Zone innerhalb der AWS-Region Frankfurt erstellt.

map_public_ip_on_launch = true

Neue EC2-Instanzen in diesem Subnet können automatisch eine öffentliche IPv4-Adresse bekommen, sofern die Einstellung bei der Instanzerstellung nicht überschrieben wird.

Wichtig: Eine öffentliche IP allein bedeutet noch nicht, dass das Subnet Internetzugang hat.



Dritter Codeblock : Zwites Subnet
Der Unterschied:
                       Subnet 1	                  Subnet 2
IP-Bereich	           10.0.1.0/24	              10.0.2.0/24
Availability Zone	   eu-central-1a	          eu-central-1b
Name	               grocerymate-public-1	       grocerymate-public-2

Warum zwei Subnetze?

Ein Application Load Balancer benötigt normalerweise Subnetze in mindestens zwei verschiedenen Availability Zones. Dadurch kann die Anwendung besser verfügbar sein.

*/ 