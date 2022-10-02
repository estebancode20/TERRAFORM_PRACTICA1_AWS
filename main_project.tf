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


provider "aws" {
  region = "us-east-1"
  access_key = "AJLASFKJFKDLSD" # definimos de forma NO SEGURA la clave de acceso, ES UNA MALA PRACTICA, solo se realiza modo de ejemplo. 
  secret_key = "45jskdjfldfsoo" # definimos de forma NO SEGURA la clave secreta, ES UNA MALA PRACTICA, solo se realiza modo de ejemplo. 
}




