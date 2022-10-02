# CON TERRAFORM LE ESTAMOS DANDO A LA NUBE... 
# EL MODELO EXACTO DE COMO DEBERÍA SER NUESTRA INFRAESTRUCTURA. 


# CUALQUIER COSA QUE SE PUEDA HACER CON LA CONSOLA DE AWS...
# PODEMOS REALIZARLO EN TERRAFORM. 

# Configuramos el proveedor AWS
provider "aws" {
  region = "us-east-1"
  access_key = "AKDJDSSS" # definimos de forma NO SEGURA la clave de acceso, ES UNA MALA PRACTICA, solo se realiza modo de ejemplo. 
  secret_key = "8kdldodkdumolsl" # definimos de forma NO SEGURA la clave secreta, ES UNA MALA PRACTICA, solo se realiza modo de ejemplo. 

}





# A modo de ejemplo definimos un recurso 
resource "<proveedor>_<tipo_de_recurso>" "nombre que le asignamos al recurso" {
    # opciones de configuración..
    key = "value"
    key2 = "another_value" 

}


# Definimos una SUBNET, vamos a crear una subred dentro de la VPC
resource "aws_subnet" "subnet-1" {
  # Como obtenemos el id del VPC correcto?
  vpc_id = aws_vpc.first-vpc # Podemos referenciar el recurso mediante el "<proveedor>_<tipo_de_recurso>" "nombre que le asignamos al recurso"
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "prod-subnet"
  }
  
}

# A TERRAFORM NO LE AFECTA EL ORDEN EN EL QUE SE DEFINAN LOS RECURSOS EN EL CODIGO, YA QUE IDENTIFICA QUE SE DEBE CREAR PRIMERO.


# Definimos una VPC ( virtual private cloud) red virtual privada en la nube.
# básicamente es una red aislada dentro del entorno de AWS.
# se pueden crear tantos vpc como sea necesario.
# cada vpc que definamos se aislara de entre sí de forma predeterminada
resource "aws_vpc" "first-vpc" {
  
  cidr_block = "10.0.0.0/16" # debemos proporcionar un bloque CIDR (classless inter-domain routing) enrutamiento entre dominios sin clases.

  # agregamos una etiqueta a la VPC.
  # sirve para poder buscar los recursos y filtrarlos por las etiquetas.
  tags = {
    Name = "production" # nombre que le asignamos a la etiqueta = production.
  }

}

# Defimos una maquina virtual como recurso
resource "aws-service" "my-first-server" {
  
    ami = "ami-83829848" # id de la maquina virtual

    
    instance_type = "t2.micro" # tipo de maquina virtual



    # agregamos etiqueta a este recurso... 
    # sirve para poder buscar los recursos y filtrarlos por las etiquetas.
    tags = {
      Name = "ubuntu" # nombre que le asignamos a la etiqueta = ubuntu.
    }


}









