#!/bin/bash
echo "何巻ですか"
read kan
mkdir -p -m +w ./ONE_PIECE/${kan}
mkdir -p -m +w ./ONE_PIECE/${kan}/raw

echo "何ページありますか"
read ans

TIME_A=`date +%s`   #A

for i in `seq 1 $ans`
do
	if [ $i -lt 10 ]; then
  		FILENAME="${kan}-00${i}"
	elif [ $i -ge 10 -a $i -lt 100 ]; then
  		FILENAME="${kan}-0${i}"
	else
  		FILENAME="${kan}-${i}"
	fi
	convert -crop 1080x1705+0+108 "./ONE_PIECE/${kan}/raw/${FILENAME}.png" "./ONE_PIECE/${kan}/${FILENAME}.jpg"
done

if [ $kan -lt 10 ]; then
  	TITLE="第0${kan}巻"
else
  	TITLE="第${kan}巻"
fi

echo "ZIPに圧縮中..."
mkdir -p -m +w "./${kan}"
cp ./ONE_PIECE/${kan}/*.jpg ./"${kan}"
zip -r "$TITLE.zip" "./${kan}"
mv "${TITLE}.zip" ./ONE_PIECE/zip/
rm -r "./${kan}"

TIME_B=`date +%s`   #B
PT=`expr ${TIME_B} - ${TIME_A}`
H=`expr ${PT} / 3600`
PT=`expr ${PT} % 3600`
M=`expr ${PT} / 60`
S=`expr ${PT} % 60`
echo "掛かった時間は${M}分${S}秒でした"

echo  "Complete !!"