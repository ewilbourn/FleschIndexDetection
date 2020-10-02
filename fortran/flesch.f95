program reader
 implicit none
 character (LEN=5000000) :: long_string, new_long_string
 character (LEN=100) :: input_string 
 integer :: char_counter, sentence_counter, space_counter, i
 character (LEN=1) :: input

 interface
   function is_sentence( l ) result(o)
     implicit none
     character(LEN=1) :: l
     logical:: o
   end function is_sentence

   function is_space (c) result (O)
     implicit none
     character(LEN=1) :: c
     logical :: O
   end function is_space
 end interface

 
 !read in the input file name form the command line
 !i.e. a.out /pub/pounds/CSC330/translations/KJV.txt
 call get_command_argument(1,input_string)
 
 !open our file
 open(unit=5,status="old",access="direct",form="unformatted",recl=1,&
  file=input_string)

  char_counter=1
  100 read (5,rec=char_counter,err=200) input
    if (index(input, "#") .ne. 0 ) then
    long_string(char_counter:char_counter) = input
    endif
    if (is_sentence(input))then
    sentence_counter=sentence_counter+1
    endif
    if(is_space(input))then
    space_counter=space_counter+1
    endif
    char_counter=char_counter+1
    goto 100
  200 continue
  char_counter=char_counter-1
  close (5)


 print *, input_string
 print *, "Read ", char_counter, " characters."
 print *, "Number of Sentences: ", sentence_counter
 print *, "Number of words: ", space_counter+1
 !print *, long_string
end program reader

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
logical function is_sentence( letter ) result(out)
  character(LEN=1) :: letter
  !character(LEN=5) :: punct
  out = .false.
  !punct =  '.:;?!'

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

logical function is_space (one_char) result (out)
  character (LEN=1) :: one_char
  out = .false.

  if (index(one_char, " ") .ne. 0) then
     out = .true.
  endif
end function is_space
