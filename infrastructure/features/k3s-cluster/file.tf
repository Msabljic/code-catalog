resource "null_resource" "this" {
  provisioner "local-exec" {
    command = "touch host.ini"
  }
}

resource "local_file" "this" {
  content_base64 = local.file_base64
  filename       = "${path.cwd}/host.ini"
  depends_on     = [null_resource.this]
}