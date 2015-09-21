echo "何巻ですか"
read kan
mkdir -p -m +w ./ONE_PIECE/${kan}
mkdir -p -m +w ./ONE_PIECE/${kan}/raw

if [ $kan -lt 10 ]; then
    TITLE="[尾田栄一郎] ONE PIECE -ワンピース- 第0${kan}巻"
else
    TITLE="[尾田栄一郎] ONE PIECE -ワンピース- 第${kan}巻"
fi

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

  echo "capturing ${FILENAME}.png..."
  adb shell screencap -p "/sdcard/${FILENAME}.png"
  adb pull "/sdcard/${FILENAME}.png" "./ONE_PIECE/${kan}/raw"
  adb shell rm "/sdcard/${FILENAME}.png"
  echo  "${i}ページ目 saved ${FILENAME}.png"
  adb shell input swipe 300 500 1000 1000
  echo  "切り出し中..."
  convert -crop 1080x1705+0+108 "./ONE_PIECE/${kan}/raw/${FILENAME}.png" "./ONE_PIECE/${kan}/${FILENAME}.jpg"
done

echo  "${kan}巻すべてキャプチャー終了！！"
adb shell sleep 2
echo  "次の巻をダウンロード"
adb shell input tap 518 1172

echo "ZIPに圧縮中..."
mkdir -p -m +w "./${kan}"
cp ./ONE_PIECE/${kan}/*.jpg ./"${kan}"
zip -r "$TITLE.zip" "./${kan}"
mv "${TITLE}.zip" ./ONE_PIECE/zip/
rm -r "./${kan}"

adb shell input tap 518 1172
echo  "Complete !!"

TIME_B=`date +%s`   #B
PT=`expr ${TIME_B} - ${TIME_A}`
H=`expr ${PT} / 3600`
PT=`expr ${PT} % 3600`
M=`expr ${PT} / 60`
S=`expr ${PT} % 60`

echo "掛かった時間は${M}分${S}秒でした"