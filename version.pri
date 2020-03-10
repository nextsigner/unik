FIRTS_APP_YEAR=2016

win32 {
    PREVNUMSEMCOMP=$$cat($$PWD/unum_sem_comp_win)
    isEmpty(PREVNUMSEMCOMP){
        PREVNUMSEMCOMP = 0
        write_file($$PWD/unum_sem_comp_win, PREVNUMSEMCOMP)
    }
}else{
    PREVNUMSEMCOMP=$$cat($$PWD/unum_sem_comp)
    isEmpty(PREVNUMSEMCOMP){
        PREVNUMSEMCOMP = 0
         system(echo "$$PREVNUMSEMCOMP" > $$PWD/unum_sem_comp)
       #write_file($$PWD/unum_sem_comp, PREVNUMSEMCOMP)
    }
}


win32 {
    #FORMAT SYSTEM DATE WITH Spanish/Argentina
    VERSION_MAJ1=$$system("echo  %date%")
    VERSION_MAJ2 =$$split(VERSION_MAJ1, "/")#07 08 2018
    VERSION_MAJ3 =$$member(VERSION_MAJ2, 2)
    VERSION_MAJ7=$$system("set /a  $$VERSION_MAJ3 - $$FIRTS_APP_YEAR")

    NUMWEEK=$$system("resources\\week2.bat")
    write_file($$PWD/unum_sem_comp_win, NUMWEEK)
    NUMCOMP=$$cat($$PWD/num_comp_win)
    isEmpty(NUMCOMP){
        NUMCOMP = 0
    }
    NNUMCOMP=$$system("set /a  $$NUMCOMP + 1")
    message(Previus numcomp $$NNUMCOMP)
    message(Previus Week Number $$PREVNUMSEMCOMP)
    RESCOMP=$$system("$$PWD/resources/compare_numsem.bat $$NUMWEEK $$PREVNUMSEMCOMP")
    greaterThan(RESCOMP, 0){
        message(Number Week not was changed: $$NUMWEEK  $$PREVNUMSEMCOMP)
    }else{
        message(Number Week changed: $$NUMWEEK $$PREVNUMSEMCOMP)
        NNUMCOMP=0
    }
    NUMCOMP=$$NNUMCOMP
    greaterThan(NUMWEEK, 9){
        message(Week Number is major that 9)
    }else{
        message(Week Number is minor that 9)
        NUMWEEK="0"$$NUMWEEK
    }
    message(Week Number $$NUMWEEK)
    write_file($$PWD/num_comp_win, NNUMCOMP)
    APPVERSION=$$VERSION_MAJ7"."$$NUMWEEK"."$$NUMCOMP
    write_file($$PWD/build_win_32/version, APPVERSION)
    message(Windows App Version $$APPVERSION)
} else:unix {
    VERSION_MAJ1=$$system(date +%Y)
    VERSION_MAJ= $$system("echo $(($$VERSION_MAJ1 - $$FIRTS_APP_YEAR))")
    VERSION_MEN1= $$system("echo $((($$system(date +%-m) * $$system(date +%-d)) + $$system(date +%-H) + $$system(date +%-M)))")

    NUMCOMP=$$cat($$PWD/num_comp)
    isEmpty(NUMCOMP){
        NUMCOMP = 0
    }

    android{
        contains(ANDROID_TARGET_ARCH,x86) {
            !contains(ANDROID_TARGET_ARCH,x86_64) {
                NNUMCOMP=$$system("echo $(($$NUMCOMP + 1))")
            }else{
                NNUMCOMP=$$NUMCOMP
            }
        }else{
            NNUMCOMP=$$NUMCOMP
        }
    }else{
        NNUMCOMP=$$system("echo $(($$NUMCOMP + 1))")
    }

    NUMSEM1=$$system(date +%W)
    NUMSEMM1=$$split(NUMSEM1, '')
    NUMSEMM2=$$member(NUMSEMM1, 0)
    NUMSEMM3=$$member(NUMSEMM1, 1)
    message(Firts number of Week $$NUMSEMM2)
    isEqual(NUMSEMM2, 0){
        message(Firts number of Week is zero)
        NUMWEEK=$$system("echo $(($$NUMSEMM3 + 1))")
    }else{
        message(Firts number of Week is not zero)
        NUMWEEK=$$system("echo $(($$NUMSEM1 + 1))")
   }
    message(Week Number $$NUMWEEK)
    system(echo "$$NUMWEEK" > $$PWD/unum_sem_comp)

    message(Previus Week Number $$PREVNUMSEMCOMP)
    RESCOMP=$$system("sh $$PWD/resources/compare_numsem.sh $$NUMWEEK $$PREVNUMSEMCOMP")
    greaterThan(RESCOMP, 0){
        message(Number Week not was changed: $$NUMWEEK  $$PREVNUMSEMCOMP)
    }else{
        message(Number Week changed: $$NUMWEEK $$PREVNUMSEMCOMP)
        NNUMCOMP=0
    }

    NUMCOMP=$$NNUMCOMP
    system(echo "$$NNUMCOMP" > $$PWD/num_comp)

    #greaterThan(NUMWEEK, 9){
        #message(Week Number is major that 9)
    #}else{
        #message(Week Number is minor that 9)
        #NUMWEEK="0"$$system("echo $(($$NUMWEEK + 1))")
        #NUMWEEK=$$system("echo $(($$NUMWEEK + 1))")
    #}
    APPVERSION=$$VERSION_MAJ"."$$NUMWEEK"."$$NUMCOMP
    message(Unix App Version $$APPVERSION)
}
