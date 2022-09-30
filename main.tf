# configuramos el proveedor AWS
provider "aws" {
  region = "us-east-1"

  # definimos de forma NO SEGURA la clave de acceso y la clave secreta, a modo de ejemplo.
  access_key = "AKDJDSSS"
  secret_key = "8kdldodkdumolsl"

}


# A modo de ejemplo definimos un recurso 
resource "<proveedor>_<tipo_de_recurso>" "nombre que le asignamos al recurso" {
    # opciones de configuración
    key = "value"
    key2 = "another_value" 

}


# defimos una maquina virtual como recurso
resource "aws-service" "my-first-server" {
  


}







