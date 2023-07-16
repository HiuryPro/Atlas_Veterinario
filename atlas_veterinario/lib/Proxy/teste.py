import os


def renomear_arquivos(caminho_pasta, novo_nome):
    count = 1
    # Verificar se o caminho é uma pasta válida
    if os.path.isdir(caminho_pasta):
        # Listar todos os arquivos na pasta
        arquivos = os.listdir(caminho_pasta)

        # Iterar sobre cada arquivo
        for arquivo in arquivos:
            # Obter o caminho completo do arquivo
            caminho_arquivo_antigo = os.path.join(caminho_pasta, arquivo)

            # Verificar se é um arquivo
            if os.path.isfile(caminho_arquivo_antigo):
                # Obter a extensão do arquivo
                _, extensao = os.path.splitext(arquivo)

                # Obter o novo caminho completo do arquivo
                caminho_arquivo_novo = os.path.join(
                    caminho_pasta, f"{novo_nome}{count}" + extensao)

                # Renomear o arquivo
                os.rename(caminho_arquivo_antigo, caminho_arquivo_novo)
                print(
                    f"Arquivo '{arquivo}' foi renomeado para '{novo_nome + str(count) + extensao}'.")
                count += 1

    else:
        print("O caminho especificado não é uma pasta válida.")


# Exemplo de uso
# Substitua pelo caminho da pasta desejada
caminho = "C:\\Users\\Hiury G\\Documents\\osso"
novo_nome = "osso"  # Substitua pelo novo nome desejado (sem a extensão)

renomear_arquivos(caminho, novo_nome)
