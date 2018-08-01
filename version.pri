VERSION_YEAR=2016
VERSION_MAJ1=$$system(date +%Y)
win32 {
    VERSION_MAJ= $$system("set /a $$VERSION_MAJ1 - $$VERSION_YEAR")
    VERSION_MEN1= $$system("set /a $$system(date +%m) + $$system(date +%d) + $$system(date +%H) + $$system(date +%M)")
} else:unix {
    VERSION_MAJ= $$system("echo $(($$VERSION_MAJ1 - $$VERSION_YEAR))")
    VERSION_MEN1= $$system("echo $(($$system(date +%m) + $$system(date +%d) + $$system(date +%H) + $$system(date +%M)))")
}
greaterThan(VERSION_MEN1, 99){
    VERSION_MEN2=$$VERSION_MEN1
}else{
    VERSION_MEN2=0$$VERSION_MEN1
}
APPVERSION=$$VERSION_MAJ"."$$system(date +%W)$$VERSION_MEN2
message(App Version $$APPVERSION)
