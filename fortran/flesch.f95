program reader
 implicit none
 character (LEN=5000000) :: long_string
 character (LEN=100) :: input_string 
 integer :: char_counter, sentence_counter
 character (LEN=1) :: input

 interface
   function is_sentence( l ) result(o)
     implicit none
     character(LEN=1) :: l
     logical:: o
   end function is_sentence
 end interface

 call get_command_argument(1,input_string)
 
 open(unit=5,status="old",access="direct",form="unformatted",recl=1,&
  file=input_string)

  char_counter=1
  100 read (5,rec=char_counter,err=200) input
    long_string(char_counter:char_counter) = input
    if (is_sentence(input))then
    sentence_counter=sentence_counter+1
    endif
    char_counter=char_counter+1
    goto 100
  200 continue
  char_counter=char_counter-1
  close (5)


!call read_file( long_string, input_string, filesize, num_sentences )
 print *, input_string
 print *, "Read ", char_counter, " characters."
 print *, "Number of Sentences: ", sentence_counter

 !print *, long_string
end program reader

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
logical function is_sentence( letter ) result(out)
  character(LEN=1) :: letter
  !character(LEN=5) :: punct
  out = .false.
  !punct =  '.:;?!'

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
