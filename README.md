# PJeOffice para Nix

O [PJeOffice](https://www.pje.jus.br/wiki/index.php/PJeOffice)
é um software disponibilizado pelo CNJ para
assinatura eletrônica de documentos para o sistema
PJe. O objetivo do aplicativo é garantir a
validade jurídica dos documentos e processos,
além de substituir a necessidade do plugin Oracle
Java Runtime Environment no navegador de internet
e gerar maior praticidade na utilização do sistema.

## Histórico de comandos

1. `dpkg -I pje-office_amd64.deb`
2. `sudo rm --interactive=once --recursive result`
3. `nix-build --impure`
4. `result/bin/pje-office`

## Links úteis

- https://www.pje.jus.br/wiki/index.php/PJeOffice
- https://cnj-pje-programs.s3-sa-east-1.amazonaws.com/pje-office/pje-office_amd64.deb
- https://github.com/nix-community/nix-direnv/wiki/Shell-integration
- https://unix.stackexchange.com/a/523174
