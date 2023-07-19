#!/bin/bash

# Verifica se o Ghostscript está instalado
if ! command -v gs &> /dev/null; then
    read -p "O Ghostscript não está instalado. Deseja instalá-lo agora? (y/n): " install_gs
    if [ "$install_gs" != "y" ] && [ "$install_gs" != "Y" ]; then
        echo "O Ghostscript é necessário para continuar. Instale-o e execute o script novamente."
        exit 1
    fi

    # Instala o Ghostscript no Ubuntu/Debian
    if command -v apt &> /dev/null; then
        sudo apt update
        sudo apt install ghostscript
    fi

    # Adicione outras instruções de instalação para outras distribuições, se necessário

    # Verifica novamente se o Ghostscript está instalado após a tentativa de instalação
    if ! command -v gs &> /dev/null; then
        echo "Não foi possível instalar o Ghostscript. Certifique-se de instalá-lo manualmente e execute o script novamente."
        exit 1
    fi
fi

# Solicita ao usuário o nome do arquivo de entrada
read -p "Digite o nome do arquivo de entrada PDF: " arquivo_entrada

# Verifica se o arquivo de entrada existe
if [ ! -f "$arquivo_entrada" ]; then
    echo "Erro: O arquivo de entrada '$arquivo_entrada' não existe."
    exit 1
fi

# Solicita ao usuário o nome do arquivo de saída
read -p "Digite o nome do arquivo de saída PDF: " arquivo_saida

# Verifica se o arquivo de saída já existe (não queremos sobrescrever)
if [ -f "$arquivo_saida" ]; then
    echo "Erro: O arquivo de saída '$arquivo_saida' já existe. Escolha outro nome."
    exit 1
fi

# Compacta o PDF usando Ghostscript
gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/ebook -dNOPAUSE -dQUIET -dBATCH -sOutputFile="$arquivo_saida" "$arquivo_entrada"

# Verifica se o Ghostscript foi bem-sucedido
if [ $? -eq 0 ]; then
    echo "Compactação concluída. O arquivo de saída é '$arquivo_saida'."
else
    echo "Ocorreu um erro durante a compactação."
fi
