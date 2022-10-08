# 1. Create VPC (Virtual Private Cloud)
# 2. Create Internet Gateway
# 3. Create Custom Route tables
# 4. Create a subnet
# 5. Associate subnet with Route Table 
# 6. Create Security Group to allow port 22, 80, 443
# 7. Create a network interface with an ip in the subnet that was created in step 4
# 8. Assign an elastic IP to the network interface created in step 7
# 9. Create an Ubuntu server and install/enable apache2

#---------------------------------------------------------------------------------------

# 1. Crear VPC (Red Virtual Privada en la nube).
# 2. Crear puerta de enlace a Internet.
# 3. Crear tablas de rutas personalizadas.
# 4. Crea una subred.
# 5. Asociar subred con tabla de rutas.
# 6. Crear grupo de seguridad para permitir el puerto 22, 80, 443.
# 7. Cree una interfaz de red con una ip en la subred que se creó en el paso 4.
# 8. Asigne una IP elástica a la interfaz de red creada en el paso 7.
# 9. Cree un servidor Ubuntu e instale/habilite apache2.

#---------------------------------------------------------------------------------------

# CON TERRAFORM LE ESTAMOS DANDO A LA NUBE... 
# EL MODELO EXACTO DE COMO DEBERÍA SER NUESTRA INFRAESTRUCTURA.



# PRIMERO DEBEMOS CREAR UN PAR DE CLAVES EN AWS, LAS QUE APARECEN MAS ABAJO SON SOLO DE EJEMPLO. 
provider "aws" {
  region     = "us-east-1"
  access_key = "AJLASFKJFKDLSD" # definimos de forma NO SEGURA la clave de acceso, ES UNA MALA PRACTICA, solo se realiza modo de ejemplo. 
  secret_key = "45jskdjfldfsoo" # definimos de forma NO SEGURA la clave secreta, ES UNA MALA PRACTICA, solo se realiza modo de ejemplo. 
}


# 1. Crear VPC (Red Virtual Privada en la nube).
# 1. Create VPC (Virtual Private Cloud)
resource "aws_vpc" "prod_vpc" { # "<proveedor>_<tipo_de_recurso>" "nombre que le asignamos al recurso"
  cidr_block = "10.0.0.0/16"    # proporcionamos un bloque CIDR (classless inter-domain routing) enrutamiento entre dominios sin clases.


  # agregamos una etiqueta a la VPC.
  # sirve para poder buscar los recursos y filtrarlos por las etiquetas.
  tags = {
    Name = "production" # nombre que le asignamos a la etiqueta = production.
  }

}



# 2. Crear puerta de enlace a Internet.(Internet Gateway)
# 2. Create Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.prod_vpc.id # este id hace referencia al id de la VPC, queremos la propiedad id de este recurso, no queremos el recurso en sí.
}





# 3. Crear tablas de rutas personalizadas.
# 3. Create Custom Route tables
resource "aws_route_table" "prod-route-table" {
  vpc_id = aws_internet_gateway.gw.id # este id hace referencia al id de la puerta de enlace

  route {
    cidr_block = "0.0.0.0/0" # bloque CIDR (classless inter-domain routing) enrutamiento entre dominios sin clases.
    gateway_id = aws_internet_gateway.gw.id
  }

  route {
    ipv6_cidr_block        = "::/0"                     # "0.0.0.0/0" es el equivalente a "::/0" pero en ipv6
    gateway_id = aws_internet_gateway.gw.id # lo apuntamos a la misma puerta de enlace (gateway_id) 

  }

  # agregamos una etiqueta a la tabla de rutas personalizadas.
  # sirve para poder buscar los recursos y filtrarlos por las etiquetas.
  tags = {
    Name = "Prod" # nombre que le asignamos a la etiqueta = Prod

  }

}



# 4. Create a subnet
# 4. Crea una subred.
resource "aws_subnet" "subnet-1" {
  vpc_id            = aws_vpc.prod_vpc.id # este id hace referencia al id de la VPC
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a" # zona de disponibilidad, los proveedores poseen varios centro de datos en una región. 

  tags = {
    Name = "prod-subnet"

  }

}

# 5. Asociar subred con tabla de rutas.
# 5. Associate subnet with Route Table
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.subnet-1.id              # este id hace referencia al id de la subred
  route_table_id = aws_route_table.prod-route-table.id # este id hace referencia al id de la tabla de rutas
}



# DEFINIR UNA POLITICA DE SEGURIDAD QUE SE LIMITE A LOS PROTOCOLOS NECESARIOS  

# 6. Crear grupo de seguridad para permitir el puerto 22, 80, 443.
# 6. Create Security Group to allow port 22, 80, 443
resource "aws_security_group" "allow_web" {
  name        = "allow_web_traffic"
  description = "allow web inbound traffic"
  vpc_id      = aws_vpc.prod_vpc.id # este id hace referencia al id de la VPC


  # Aquí aplicamos las diferentes reglas
  # Politica de ingreso
  ingress = {
    # vamos a permitir el tráfico TCP en el puerto 443
    # El from_port y el to_port nos permite definir un rango de puertos  
    # En caso que el from_port y el to_port sea el mismo, implica que estamos permitiendo solo ese puerto.
    description = "HTPPS" # Esto es tecnicamente trafico https
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_block  = ["0.0.0.0/0"] # "0.0.0.0/0" implica que cualquier direccion ip puede ingresar a ella
    # cidr_block = ["1.1.1.1/32"]  pero si solo quisieramos una ip específica, como "1.1.1.1/32", definimos que solo conoce esa direccion ip


    # PODEMOS TENER TANTAS POLITICAS DE ENTRADA Y SALIDAS COMO QUERAMOS

    description = "HTPPS" # Esto es trafico https
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_block  = ["0.0.0.0/0"]

    description = "SSH"
    from_port   = 2
    to_port     = 2
    protocol    = "tcp"
    cidr_block  = ["0.0.0.0/0"]

  }

  # Politica de salida
  egress = {
    # 0 quiere decir que estamos permitiendo todos los puertos en la direccion de salida
    from_port  = 0
    to_port    = 0
    protocol   = "-1" # -1 implica que puede ser cualquier protocolo
    cidr_block = ["0.0.0.0/0"]


    # agregamos etiqueta a este recurso... 
    # sirve para poder buscar los recursos y filtrarlos por las etiquetas.
    tags = {
      Name = "allow_web" # nombre que le asignamos a la etiqueta = allow_web

    }

  }

}


# 7. Cree una interfaz de red con una ip en la subred que se creó en el paso 4.
# 7. Create a network interface with an ip in the subnet that was created in step 4
resource "aws_network_interface" "web-server-nic" {
  subnet_id   = aws_subnet.subnet-1.id # este id hace referencia a la subred
  private_ips = ["10.0.1.50"]          # podemos elegir cualquier direccion ip dentro de la subred...
  # excepto las que son reservadas por AWS. 

  security_groups = [aws_security_group.allow_web.id] # este id hace referencia al id del grupo de seguridad


  # attachment {  # podemos adjutarlo a un dispositivo, pero lo omitimos por ahora
  #   instance = "${aws_instance.test.id}"
  #   device_index = 1
  # }


}


# 8. Asigne una IP elástica a la interfaz de red creada en el paso 7.
# 8. Assign an elastic IP to the network interface created in step 7
resource "aws_eip" "one" {
  vpc                       = true                                    # es booleano, si la direccion ip está o no en una VPC 
  network_interface         = aws_network_interface.web-server-nic.id # este id hace referencia a la interfaz de red
  associate_with_private_ip = "10.0.1.50"
  depends_on                = aws_internet_gateway.gw # hacemos referencia a todo el objeto "puerta de enlace a internet ", no solo al id 
  # la direccion ip elastica requiere que exista una puerta de enlace a internet antes de la asociación
}


# 9. Cree un servidor Ubuntu e instale/habilite apache2.
# 9. Create an Ubuntu server and install/enable apache2
resource "aws_instance" "web-server-instance" {
  ami           = "ami-08598383299" # ami ubuntu server
  instance_type = "t2.micro"        # tipo de instancia

  # zona donde está la subnet
  availability_zone = "us-east-1a" # zona de disponibilidad, los proveedores poseen varios centro de datos en una región. 
  # sino especificas la zona, Amazon elegirá una zona de disponibilidad aleatoria para implemetarla
  # no es recomendable tener un servidor en una zona y la subred en distintas zonas, ya que puede causar problemas.
  #Es mejor especificar la zona de disponibilidad a que Amazon escoja aleatoriamente. 
  
  key_name = "main-key" # referencia al par de claves para acceder a nuestro dispositivo

  network_interface { #  Bloque interfaz de red
    
    device_index = 0 # definimos que esta sea su primera interfaz configurandolo en cero.
                     # como en cualquier lenguaje de programacion el primer numero con el que empiezas es 0 en lugar de 1.


    network_interface_id = aws_network_interface.web-server-nic.id # este id hace referencia al id de la interfaz de red


  }

  tags = {
    Name = "web-server" # nombre que le asignamos a la etiqueta = web-server


  }  

  # secuencia de comandos bash para instalar apache web server
  user_data = <<-EOF 
                 #!/bin/bash
                 sudo apt update -y
                 sudo apt install apache2 -y
                 sudo systemctl start apache2
                 sudo bash -c 'echo your very web server > /var/www/html/index.html'
                 EOF     
}











































