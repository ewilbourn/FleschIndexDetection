!Emily Wilbourn
!flesch fortran program

program reader
 implicit none
 character (LEN=5000000) :: long_string, new_long_string, dale_chall
 character (LEN=80) :: input_string , new_input_string , n_input_string
 character (LEN=20) :: word
 character (LEN=5) :: new_word
 character (LEN=20), dimension(50000000) :: tokenized_words, tokenized_dc
 integer :: char_counter, sentence_counter, space_counter, pos1 = 1, pos2,&
            i,j, n=0, word_counter=0, word_counter_dc=0, filesize, syllable_counter, &
            total_syllable_counter, d_char_counter
 character (LEN=1) :: input
 character (LEN=4) :: file_ending
 !create an integer array of the lengths of each word in the tokenized_words
 integer, dimension(50000000) :: word_lengths 
 real :: flesch, flesch_kincaid, dale_chall_index
 character (LEN=5) :: fk_formatted
 character (LEN=30) :: format


 !an interface is fortran's version of a C++ prototype
 interface
   function is_sentence( l ) result(o)
     implicit none
     character(LEN=1) :: l
     logical:: o
   end function is_sentence

   function is_space (l) result (o)
     implicit none
     character(LEN=1) :: l
     logical :: o
   end function is_space

   function is_number (w, w_length) result (val)
     implicit none
     integer :: num, i, w_length, counter
     character (LEN=*) :: w
     logical :: val
   end function is_number
   
   function to_upper(in) result(out)
     implicit none
     character(LEN=1) :: in
     character(:), allocatable :: out
   end function to_upper

   function other_punct (l) result (o)
     implicit none
     character(LEN=1) :: l
     logical :: o
   end function other_punct

   function sameString(s1,s2) result (o)
     implicit none
     character(LEN=*) :: s1,s2
     logical :: o
   end function sameString
  
   function is_new_line (l) result (o)
     implicit none
     character(LEN=1) :: l
     integer :: i
     logical :: o
   end function is_new_line
 
   function countSyllables (s1, word_length) result (o)
   character(LEN=*) ::s1
   integer :: o
   integer :: word_length
  
   !initialize the previous_letter to be false, since in a word, the first
   !letter, which is the current_letter, doesn't have any letters in front
   !of it
   logical :: previous_letter=.false.
   logical :: current_letter
   end function countSyllables
   
   function is_vowel(l) result (o)
   character(LEN=1) :: l
   logical :: o
   end function is_vowel
 
 end interface

 !define how I want numbers to be formatted : with 5 digits and 1 decimal place 
 format = "F5.1" 
 !read in the input file name form the command line
 !i.e. a.out KJV.txt
 call get_command_argument(1,input_string)
 !extracting the file name before the .txt to use when outputting which file we
 !are translating
 new_word = input_string(1:(index(input_string, "."))-1)
 n_input_string = "/pub/pounds/CSC330/translations/"//input_string

 inquire(file = n_input_string, size = filesize)
 i = 1
 !open our file
 open(unit=5,status="old",access="direct",form="unformatted",recl=1,&
  file=n_input_string)
 
  char_counter=1
  100 read (5,rec=i,err=200) input
  i = char_counter   
    if(is_new_line(input))then
      input = " "
    end if
    if (is_sentence(input)) then
      sentence_counter=sentence_counter+1
    endif
    if ((.not. is_sentence(input)) .and. (.not.other_punct(input))) then
      long_string(char_counter:char_counter) = to_upper(input)
    endif
    char_counter=char_counter+1
    i = i+1
    goto 100
  200 continue
  char_counter=char_counter-1
  close (5)

 !do i = 1, char_counter
 !   print *, "Input: ", long_string(i:i)
 !end do


 !open dale-chll file and put all the characters into a string
 open(unit=5,status="old",access="direct",form="unformatted",recl=1,&
  file="/pub/pounds/CSC330/dalechall/wordlist1995.txt")

  d_char_counter=1
  50 read (5,rec=d_char_counter,err=150) input
    if(is_new_line(input))then
    input = " "
    end if
    if ((.not. is_sentence(input)) .and. (.not.other_punct(input)))then
    dale_chall(d_char_counter:d_char_counter) = to_upper(input)
    endif
    d_char_counter=d_char_counter+1
    goto 50
  150 continue
  d_char_counter=d_char_counter-1
  close (5)
 ! print *, "Dale Chall Size", d_char_counter 


 !this code came from Rosetta Code
 !http://www.rosettacode.org/wiki/Tokenize_a_string#Fortran
 do 
   pos2 = index(long_string(pos1:), " ")
   !pos2 being equal to 0 indicates that it wasn't found 
   if (pos2 == 0) then
      n = n+1
      tokenized_words(n) = long_string(pos1:)
      exit
   end if

   !if the tokenized word is not a number, then add it to the 
   !tokenized_words list
   if(.not. is_number(long_string(pos1:pos2+pos1-2), &
   len(long_string(pos1:pos2+pos1-2)))) then
   n = n+1
   tokenized_words(n) = long_string(pos1:pos2+pos1-2)
     if(len(long_string(pos1:pos2+pos1-2)) > 0) then
     word_counter=word_counter+1
     !print*, "length: ", len(long_string(pos1:pos2+pos1-2))
     end if
   end if
   pos1 = pos2+pos1
 end do

 ! loop to count the number of syllables in each word
 syllable_counter = 0
 total_syllable_counter = 0
 do j = 1, n, 1
    word = tokenized_words(j)
   do i = 1, len(word), 1
    if (is_vowel(word(i:i))) then
     syllable_counter = syllable_counter + 1
    end if
    if( i == n .and. (index(word(i:i),"E") .ne. 0)) then
        syllable_counter = syllable_counter -1
    end if
  end do
  if(syllable_counter == 0)then
        syllable_counter = 1
  end if
  total_syllable_counter = total_syllable_counter + syllable_counter

 end do


 !tokenize the dale_chall list of words held in dale_chall
 !this code came from Rosetta Code
 !http://www.rosettacode.org/wiki/Tokenize_a_string#Fortran
 do
   pos2 = index(dale_chall(pos1:), " ")
   
   !pos2 being equal to 0 indicates that it wasn't found 
   if (pos2 == 0) then
      n = n+1
      tokenized_dc(n) = long_string(pos1:)
      exit
   end if

   !if the tokenized word is not a number, then add it to the 
   !tokenized_words list
   if(.not. is_number(dale_chall(pos1:pos2+pos1-2), &
   len(dale_chall(pos1:pos2+pos1-2)))) then
   n = n+1
   tokenized_dc(n) = dale_chall(pos1:pos2+pos1-2)

     !if the length of the substring of the dale_chall string is greater
     !than zero, then add it to the string of tokenized words
     if(len(dale_chall(pos1:pos2+pos1-2)) > 0) then
     word_counter_dc=word_counter_dc+1
     !print*, "length: ", len(long_string(pos1:pos2+pos1-2))
     end if
   end if
   !update position 1 (pos1) 
   pos1 = pos2+pos1
 end do

 !loop to determine the dall_chall word count 
 do i = 1, d_char_counter, 1
   if(.not. sameString(tokenized_dc(i),tokenized_words(i))) then
   word_counter_dc = word_counter_dc+1
   end if
 end do
  
 flesch = 206.835-((real(syllable_counter)/real(word_counter))*84.6)-&
 ((real(word_counter)/real(sentence_counter))*1.015)

 flesch_kincaid =(((real(syllable_counter)/real(word_counter))*11.8)) +&
 (((real(word_counter)/real(sentence_counter))*0.39)) - 15.59
 
 dale_chall_index =(real(word_counter_dc)/real(word_counter))*100*0.1579+&
((real(word_counter)/real(sentence_counter))*0.0496)

 if (((real(word_counter_dc)/real(word_counter))*100) > 5)then
 dale_chall_index = dale_chall_index+3.6365
 end if
 
 !read(*, format) flesch_kincaid, dale_chall_index

 !NINT(flesch) prints out the rounded flesch index
 print*,"Fortran      ", new_word, NINT(flesch), "   ", flesch_kincaid, "  ",& 
 dale_chall_index
 !write(*, format) "Fortran      ", new_word, "", NINT(flesch), "  ", &
 !flesch_kincaid, " ", dale_chall_index

end program reader

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

!function that returns a logical (true/false) that tells us 
! if a character is actually punctuation that defines a sentence
logical function is_sentence( letter ) result(out)
  character(LEN=1) :: letter
  out = .false.

  !the index being equal to 0 indicates that something
  !isn't found, so if the index isn't equal to 0 then
  !set found equal to true
  if (index(letter,".") .ne. 0) then
    out = .true.
  else if (index(letter,":") .ne. 0) then
    out = .true.
  else if (index(letter,";") .ne. 0) then
    out = .true.
  else if (index(letter,"?") .ne. 0) then
    out = .true.
  else if (index(letter,"!") .ne. 0) then
    out = .true.
  endif
end function is_sentence


!function that determines if a character is one of the 
!characters that needs to be removed from the file
!precondition: pass in a character (length = 1)
!postcondition: return true if the index of the character is 
!not zero when compared to a specific character, false if it is zero
logical function other_punct(letter) result (out)
  character(LEN=1) :: letter
  out = .false.
  if (index(letter,"#") .ne. 0) then
    out = .true.
  else if (index(letter,"[") .ne. 0) then
    out = .true.
  else if (index(letter,"]") .ne. 0) then
    out = .true.
  else if (index(letter,",") .ne. 0) then
    out = .true.
  else if (index(letter,"$") .ne. 0) then
    out = .true.
  else if (index(letter,"'") .ne. 0) then
    out = .true.
  endif
end function other_punct


!function that determines if a character is a vowel
!precondition: pass in a character (length = 1)
!postcondition: return true if the index of the character is 
!not zero when compared to a vowel, false if it is zero
logical function is_vowel(letter) result (out)
  character(LEN=1) :: letter
  out = .false.
  if (index(letter,"A") .ne. 0) then
    out = .true.
  else if (index(letter,"E") .ne. 0) then
    out = .true.
  else if (index(letter,"I") .ne. 0) then
    out = .true.
  else if (index(letter,"O") .ne. 0) then
    out = .true.
  else if (index(letter,"U") .ne. 0) then
    out = .true.
  else if (index(letter,"Y") .ne. 0) then
    out = .true.
  endif
end function is_vowel

!function that determines if a character is a space
!precondition: pass in a character (length = 1)
!postcondition: return true if the index of the character is 
!not zero when compared to a space, false if it is zero
logical function is_space (one_char) result (out)
  character (LEN=1) :: one_char
  out = .false.

  if (index(one_char, " ") .ne. 0) then
     out = .true.
  endif
end function is_space


!function that determines if the ascii character of
!a character matches the ascii numbers
!precondition: pass in an integer (ascii value)
!postcondition: return true if the ascii integer value matches
!that of a number, and false if it doesn't
logical function is_number (word, word_length) result (val)
  integer :: num, i, word_length, counter
  character (LEN=*) :: word
  val = .false.
  counter = 0
  !iterate through the string that was passed in
  !anytime we find a number in the string, we increment 
  !our counter
  iloop:do i = 1, word_length,1
  jloop:do j = 48, 57, 1


  !if the ascii value of the current character equals that of 
  !j, a number ascii value (i.e. the ascii value for 0, 1, 2, etc.),
  !then increment our counter
  if (iachar(word(i:i)) == j) then
  counter = counter+1
  endif 

  end do jloop 
  end do iloop


  !the counter is equal to the word length, then we know 
  !we have a number because each character in the string is
  !a digit
  if (counter == word_length) then
  val = .true.
  end if

end function is_number

!function that determines if the ascii decimal value of
!a character matches the ascii decimal value for a carriage return
!precondition: pass in an integer (ascii value)
!postcondition: return true if the ascii integer value matches
!that of a number, and false if it doesn't
logical function is_new_line (one_char) result (out)
  character(LEN=1) :: one_char
  integer :: i
  out = .false.

  i = iachar(one_char)
  if (i ==10)then
  out = .true.
  endif 

end function is_new_line
!function to make a single character uppercase
!this came from Dr. Pounds
!I need to use this on my tokenized words as well as
!the tokenized dale-chall list so that I can properly 
!compare words
function to_upper(in) result(out)

character(LEN=1)  :: in
character(:), allocatable :: out
integer                   :: i, j

! The following should work with any character set 
character(*), parameter   :: upp = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
character(*), parameter   :: low = 'abcdefghijklmnopqrstuvwxyz'
out = in                                            
do i = 1, LEN_TRIM(out)             
    j = INDEX(low, out(i:i))        
    if (j > 0) out(i:i) = upp(j:j)  
end do

end function to_upper

!function that compares two strings (came from Dr. Pounds)
!precondition: pass in two strings
!postcondition: return a logical (true if strings are the same,
!false if they are not)
logical function sameString ( string1, string2 ) result(out)

character(LEN=*) :: string1, string2
out = .false.

if ( index(trim(adjustl(string1)), trim(adjustl(string2))) .ne. 0 ) then
out = .true.
endif

end function sameString

