#!/bin/bash

# AUTOR: Tomir Domański 305005
# Student Fizyki Medycznej, Fizyka Techniczna
# Politechnika Warszawska

# Kolory do szybszego odczytywania komunikatow - ANSI escape codes
GREEN=$'\e[0;32m'
RED=$'\e[0;31m'
NC=$'\e[0m'

# Obsluga braku 1 argumentu programu 
# jezeli uzytkownik nie poda argumentu 
# program zakonczy dzialanie
if test -z "$1" 
then
    printf "${RED}Nie podano 1 argumentu - pliku ze stronami www\n${NC}"
    exit 1
fi

# Obsluga pustego pliku podanego w 1 argumencie
# jezeli uzytkownik dostarczy pusty plik (rozmiar pliku rowny zero)
# program zakonczy dzialanie
# w przeciwnym razie program kontynuje dzialanie
if [ -s "$1" ]
then
     printf "${NC}Program uruchomiony prawidlowo\n"
else
     printf "${RED}Plik "$1" jest pusty\n${NC}"
     exit 2
fi

# Za pomoca funkcji cat plik z argumentu 1 jest przeszukiwany linijka po linijce
for line in `cat $1`
do
    # Usuwany jest znak powrotu karetki
    line="${line/$'\r'/}"

    # Funkcja wget pobiera strone bez komunikatow (-q) na wyjscie (-O) temp.txt
    wget -q -O temp.txt $line

    # Usuwane sa niepotrzebne znaki do oznaczenia plikow ze stronami www
    line="${line/$'http://www.'/}"
    line="${line/$'https://www.'/}"
    line="${line/$'http://'/}"
    line="${line/$'https://'/}"
    # Zapisywana jest oryginalna linijka strony internetowej
    lineOrig=$line
    # W celu uniknięcia błędów w oznaczeniach plikow zastąpujemy symbol '/' symbolem '_'
    line=${line//'/'/_}

    # Sprawdzenie czy istnieje plik do porownania wczesniejszej wersji strony
    if [ -f "$line" ]
    then 
        
        # Funkcja cmp -s pozwala na sprawdzenie czy zawartosc temp rozni sie od line
        # jezeli tak to program zwroci informacje o zmianie strony
        if cmp -s temp.txt $line
        then
            printf "${GREEN}Strona "$lineOrig" sie nie zmienila\n${NC}" 
        else
            printf "${RED}Strona "$lineOrig" sie zmienila\n${NC}"
        fi

        # Funkcja mv zmienia nazwe pliku z temp.txt na nazwe strony
        mv temp.txt $line
    else 

        # Funkcja mv zmienia nazwe pliku z temp.txt na nazwe strony
        mv temp.txt $line
        printf "${NC}Utworzono plik strony "$lineOrig"\n" 
    fi
done 