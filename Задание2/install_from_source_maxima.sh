#!/bin/bash

git clone https://github.com/andrejv/maxima.git
cd maxima

# формирование необходимых файлов конфигурации
./bootstrap

# конфигурация по умолчанию
./configure

# сборка и проверка
make
make check
make install

