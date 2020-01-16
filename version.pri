VERSION_YEAR=2016
win32 {
    #FORMAT SYSTEM DATE WITH Spanish/Argentina
    VERSION_MAJ1=$$system("echo  %date%")
    VERSION_MAJ2 =$$split(VERSION_MAJ1, "/")#07 08 2018
    VERSION_MAJ3 =$$member(VERSION_MAJ2, 2)
    VERSION_MAJ4 =$$split(VERSION_MAJ3, "")
    VERSION_MAJ5 =$$member(VERSION_MAJ4, 2)
    VERSION_MAJ6 =$$member(VERSION_MAJ4, 3)
    VERSION_MAJ7=$$system("set /a  $$VERSION_MAJ3 - $$VERSION_YEAR")

    MDIA1=$$member(VERSION_MAJ2, 0)
    MDIA2=$$split(MDIA1, "")
    MDIA3=$$member(MDIA2, 0)
    greaterThan(MDIA1, 9){
        message(DIA mayor que 9: $$MDIA1)
        MDIA4=$$MDIA1
    }else{
        message(DIA menor igual que 9)
        MDIA4=$$member(MDIA2, 1)
    }
    MES=$$member(VERSION_MAJ2, 1)
    ARRAYMES=$$split(MES, "")
    greaterThan(MES, 9){
        message(MES mayor que 9: $$MES)

    }else{
        message(MES menor igual que 9: $$MES)
        MES=$$member(ARRAYMES, 1)
    }
    VERSION_MEN1=$$system("echo  %time%")
    VERSION_MEN2 =$$split(VERSION_MEN1, ":")#07 08 2018
    VERSION_MEN3 =$$member(VERSION_MEN2, 1)
    VERSION_MEN4=$$system("resources\\week.bat $$MDIA4 $$MES $$member(VERSION_MAJ2, 2)")
    NUMWEEK=$$system("set /a  $$VERSION_MEN4 + 1")
    message(DIA: $$MDIA4)
    message(MES: $$MDIA4)

    greaterThan(NUMWEEK, 9){
        message(Week Number is major that 9)
    }else{
        message(Week Number is minor that 9)
        NUMWEEK="0"$$NUMWEEK
    }
    message(Week Number $$NUMWEEK)

    #message(Date: $$MDIA1)
    #message(Month: $$member(VERSION_MAJ2, 1))
    #message(Week: $$NUMWEEK)

    VERSION_MEN5=$$system("echo  %time%")
    VERSION_MEN6 =$$split(VERSION_MEN5, ":")
    VERSION_MEN7 =$$member(VERSION_MEN6, 0)
    VERSION_MEN8 =$$member(VERSION_MEN6, 1)
    VERSION_MEN9=$$system("set /a  $$MDIA4 + $$MMES4 + $$VERSION_MEN7 + $$VERSION_MEN8")
    greaterThan(VERSION_MEN9, 99){
        VERSION_MEN10=$$VERSION_MEN9
    }else{
        VERSION_MEN10=0$$VERSION_MEN9
    }
    APPVERSION=$$VERSION_MAJ7"."$$NUMWEEK$$VERSION_MEN10
    message(Windows App Version $$APPVERSION)
} else:unix {
    VERSION_MAJ1=$$system(date +%Y)
    VERSION_MAJ= $$system("echo $(($$VERSION_MAJ1 - $$VERSION_YEAR))")
    VERSION_MEN1= $$system("echo $((($$system(date +%-m) * $$system(date +%-d)) + $$system(date +%-H) + $$system(date +%-M)))")

    NUMCOMP=$$cat($$PWD/num_comp)
    isEmpty(NUMCOMP){
        NUMCOMP = 0
    }

    android{
        contains(ANDROID_TARGET_ARCH,x86) {
            !contains(ANDROID_TARGET_ARCH,x86_64) {
                NNUMCOMP=$$system("echo $(($$NUMCOMP + 1))")
            }
        }
    }else{
        NNUMCOMP=$$system("echo $(($$NUMCOMP + 1))")
    }

    NUMCOMP=$$NNUMCOMP
    write_file($$PWD/num_comp, NNUMCOMP)

    NUMSEM1=$$system(date +%W)
    NUMSEM2=$$system("echo $(($$NUMSEM1 + 1))")
    message(Week Number $$NUMSEM2)
    greaterThan(NUMSEM2, 9){
        message(Week Number is major that 9)
    }else{
        message(Week Number is minor that 9)
        NUMSEM2="0"$$system("echo $(($$NUMSEM1 + 1))")
    }
    APPVERSION=$$VERSION_MAJ"."$$NUMSEM2"."$$NUMCOMP
    message(Unix App Version $$APPVERSION)
}
