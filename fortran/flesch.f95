program reader
 implicit none
 character (LEN=5000000) :: long_string, new_long_string, dale_chall
 !character, dimension(:), allocatable :: long_string, new_long_string, dale_chall
 character (LEN=100) :: input_string 
 character (LEN=20) :: word
 character (LEN=20), dimension(50000000) :: tokenized_words, tokenized_d_c
 !character, dimension(:), allocatable :: tokenized_words, tokenized_d_c
 integer :: char_counter, sentence_counter, space_counter, pos1 = 1, pos2,&
            ascii, i,j, n=0, word_counter=0, filesize, syllable_counter
 character (LEN=1) :: input

 !create an integer array of the lengths of each word in the tokenized_words
 integer, dimension(50000000) :: word_lengths 

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

 
 !read in the input file name form the command line
 !i.e. a.out /pub/pounds/CSC330/translations/KJV.txt
 call get_command_argument(1,input_string)
 
 inquire(file = input_string, size = filesize)

 !open our file
 open(unit=5,status="old",access="direct",form="unformatted",recl=1,&
  file=input_string)

  char_counter=1
  100 read (5,rec=char_counter,err=200) input
    if(is_new_line(input))then
    input = " "
    end if
    if ((.not. is_sentence(input)) .and. (.not.other_punct(input))) then
    long_string(char_counter:char_counter) = to_upper(input)
    endif
    if (is_sentence(input))then
    sentence_counter=sentence_counter+1
    endif
    char_counter=char_counter+1
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

  char_counter=1
  i = 1
  50 read (5,rec=char_counter,err=150) input
    if(is_new_line(input))then
    input = " "
    end if
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
   !pos2 being equal to 0 indicates that it wasn't found 
   if (pos2 == 0) then
      n = n+1
      tokenized_words(n) = long_string(pos1:)
      exit
   end if

   !if the tokenized word is not a number, then add it to the tokenized_words
   !list
   if(.not. is_number(long_string(pos1:pos2+pos1-2), &
   len(long_string(pos1:pos2+pos1-2)))) then
   n = n+1
   tokenized_words(n) = long_string(pos1:pos2+pos1-2)
   end if
   pos1 = pos2+pos1
 end do

 ! position 1, or pos1, is where we start each word
 !pos1 = 1
 !position 2, or pos2, is where we find the space
 !do while (pos2 .ne. filesize+1)
   
   !if the index of the character we are looking at when compared to " "
   !is not 0, then it is found and we can allocate memory for it in our 
   !character array
  ! if(index(long_string(pos2:pos2), " ") .ne. 0) then
      
     !filling up the memory we allocated with the word we found
  !   word=long_string(pos1:pos2)
     
     !allocate memory for the word (which is the length from position 2 to
     !position 1
  !   allocate(tokenized_words(pos2-pos1))
     
     !increment the number of words
  !   word_counter = word_counter+1
     
     !deallocating memory
  !   deallocate(tokenized_words)
  ! end if
! end do
 do i = 1, n
   word = tokenized_words(i)
   print*,"Token:",tokenized_words(i)
           
   word_counter = word_counter+1
 end do
! print *,"Word Count: ", word_counter
 !print *, tokenized_words
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

if ( len(trim(adjustl(string1))) .eq. len(trim(adjustl(string2))) ) then
    if ( index(trim(adjustl(string1)), trim(adjustl(string2))) .ne. 0 ) out = .true.
endif

end function sameString


!function that counts the number of syllables in a word
!precondition: pass in a string and the length of the string (integer)
!postcondition: return an integer that holds the number of syllables in a word
integer function countSyllables (string1, word_length) result (out)
   character(LEN=*) ::string1
   integer :: word_length
   !initialize the previous_letter to be false, since in a word, the first
   !letter, which is the current_letter, doesn't have any letters in front
   !of it
   logical :: previous_letter, is_syllable
   character(LEN=1) :: letter
   logical :: current_letter
   previous_letter = .false.
   is_syllable = .false.
   out = 0
   
  do i = 1, word_length, 1
   if (index(string1(i:i),"A") .ne. 0) then
    is_syllable = .true.
   else if (index(string1(i:i),"E") .ne. 0) then
    is_syllable = .true.
   else if (index(string1(i:i),"I") .ne. 0) then
    is_syllable = .true.
   else if (index(string1(i:i),"O") .ne. 0) then
    is_syllable = .true.
   else if (index(string1(i:i),"U") .ne. 0) then
    is_syllable = .true.
   else if (index(string1(i:i),"Y") .ne. 0) then
    is_syllable = .true.
   end if
   if (.not.((i == word_length) .and. (index(string1(i:i),"E") .ne. 0) .and.&
       (previous_letter .eqv. .false.)))then
   if(is_syllable)then
     out=out+1
     current_letter = .true.
   end if
   if(current_letter .eqv. previous_letter)then
     out = out -1
   end if
   end if
   end do

   if(out == 0)then
        out = 1
   end if
end function countSyllables


