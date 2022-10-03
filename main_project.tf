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
  vpc_id = aws_vpc.prod_vpc.id # este id hace referencia a la VPC, queremos la propiedad id de este recurso, no queremos el recurso en sí.
}





# 3. Crear tablas de rutas personalizadas.
# 3. Create Custom Route tables
resource "aws_route_table" "prod-route-table" {
  vpc_id = aws_internet_gateway.gw.id # este id hace referencia a la puerta de enlace

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  route {
    ipv6_cidr_block        = "::/0"                     # "0.0.0.0/0" es el equivalente a "::/0" pero en ipv6
    egress_only_gateway_id = aws_internet_gateway.gw.id # lo apuntamos a la misma puerta de enlace (gateway_id) 

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
  vpc_id = aws_vpc.prod_vpc.id # este id hace referencia a la VPC
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a" # zona de disponibilidad, los proveedores poseen varios centro de datos en una región. 

  tags = {
    Name = "prod-subnet"

  }

}

# 5. Asociar subred con tabla de rutas.
# 5. Associate subnet with Route Table



















