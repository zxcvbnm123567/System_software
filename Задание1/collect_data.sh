#!/bin/bash

echo -e Название_файла, Расширение_файла, Размер_файла, Дата_последнего_изменения, Длительность > "collected_data.csv"

find . -name "*"|while read FILE; do
	# без idot файла и полученного файла collected_data.csv
	if [[ "$FILE" != "." ]] && [[ "$FILE" != "./collected_data.csv" ]];
	then
		basename=$(basename -- "$FILE")
		# имя файла (до точки)
		filename="${basename%.*}"
		# расширение файла (после точки)
		extension="${basename##*.}"

		# определение типа файла с проверкой содержимого
		mime_t=$(file -b --mime-type "$FILE")
		IFS='/' read -ra type_ext_arr <<< "$mime_t"
		file_type=${type_ext_arr[0]}
		
		# размер файла в байтах
		filesize=$(find "$FILE" -printf "%s")
		# дата последнего изменения
		lastmodify=$(stat -c %y "$FILE" | cut -d' ' -f1)
		
		
		# находим длительность для аудио и видео
		if [[ "$file_type" == "audio" ]];
		then
			duration=$(mediainfo --Inform="Audio;%Duration%" $FILE)
		elif [[ "$file_type" == "video" ]];
		then
			duration=$(mediainfo --Inform="Video;%Duration%" $FILE)
		else
			duration='' # нет длительности
		fi
				
		# добавление в конец файла
		echo -e $filename, $extension, $filesize, $lastmodify, $duration>> "collected_data.csv"
	fi
done

