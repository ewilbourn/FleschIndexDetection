program reader
 implicit none
 character (LEN=5000000) :: long_string, new_long_string, dale_chall
 character (LEN=100) :: input_string 
 character (LEN=50) :: temp_string
 character (LEN = 20), dimension(5000000) :: tokenized_words, tokenized_d_c
 integer :: char_counter, sentence_counter, space_counter, pos1 = 1, pos2,&
            ascii, i, n=0, word_counter=0,pos3
 character (LEN=1) :: input

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

   function is_number (ascii_num) result (o)
     implicit none
     integer :: ascii_num
     logical :: o
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
 end interface

 
 !read in the input file name form the command line
 !i.e. a.out /pub/pounds/CSC330/translations/KJV.txt
 call get_command_argument(1,input_string)
 
 !open our file
 open(unit=5,status="old",access="direct",form="unformatted",recl=1,&
  file=input_string)

  char_counter=1
  100 read (5,rec=char_counter,err=200) input
    if ((.not. is_sentence(input)) .and. (.not.other_punct(input)))then
    long_string(char_counter:char_counter) = to_upper(input)
   ! print *, "Input: ", input
    endif
    if (is_sentence(input))then
    sentence_counter=sentence_counter+1
    endif
    char_counter=char_counter+1
    goto 100
  200 continue
  char_counter=char_counter-1
  close (5)

 do i = 1, char_counter
    print *, "Input: ", long_string(i:i)
 end do
 !open dale-chll file and put all the characters into a string
 open(unit=5,status="old",access="direct",form="unformatted",recl=1,&
  file="/pub/pounds/CSC330/dalechall/wordlist1995.txt")

  char_counter=1
  50 read (5,rec=char_counter,err=150) input
    if ((.not. is_sentence(input)) .and. (.not.other_punct(input)))then
    dale_chall(char_counter:char_counter) = to_upper(input)
    endif
    char_counter=char_counter+1
    goto 50
  150 continue
  char_counter=char_counter-1
  close (5)
  print *, "Dale Chall Size", char_counter 

 !this code came from Rosetta Code
 !http://www.rosettacode.org/wiki/Tokenize_a_string#Fortran

 do 
   pos2 = index(long_string(pos1:), " ")
   print*, "String: ", long_string(pos1:)
   print*, "pos2: ", pos2 
   print*, "pos1: ", pos1
   print*, " "
   !pos2 being equal to 0 indicates that it wasn't found 
   if (pos2 == 0) then
      n = n+1
      tokenized_words(n) = long_string(pos1:)
      exit
   end if
   n = n+1
   tokenized_words(n) = long_string(pos1:pos1+pos2-2)
   pos1 = pos2+pos1
 end do

 do i = 1, n
    !    print*,"Token:",tokenized_words(i)
        word_counter = word_counter+1
 end do
 !print *, word_counter
 !print *, tokenized_words
 !print *, new_long_string
 !print *, "Read ", char_counter, " characters."
 !print *, "Number of Sentences: ", sentence_counter
 !print *, "Number of words: ", space_counter+1
 !print *, long_string
end program reader

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
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
logical function is_number (num) result (out)
  integer :: num
  integer :: i
  out = .false.

  do i = 48, 57, 1
  if (num == i) then
  out = .true.
  endif 
  end do

end function is_number

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

if ( len(trim(adjustl(string1))) .eq. len(trim(adjustl(string2))) ) then
    if ( index(trim(adjustl(string1)), trim(adjustl(string2))) .ne. 0 ) out = .true.
endif

end function sameString

