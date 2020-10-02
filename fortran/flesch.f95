program reader
 implicit none
 character (LEN=5000000) :: long_string
 integer :: filesize, num_sentences,i
 character (LEN=100) :: input_string 
 integer :: char_counter
 integer :: sentence_counter
 character (LEN=1) :: input
 logical :: found

 interface
   subroutine read_file( string, i_string, char_counter, sentence_counter )
     character (LEN=5000000) :: string
     character (LEN=100) :: i_string
     integer :: char_counter !counter represents the filesize
     integer :: sentence_counter
   end subroutine read_file
   
   function is_sentence( l ) result(o)
     implicit none
     character(LEN=1) :: l
     logical:: o
   end function is_sentence

   subroutine count_sentences( string, num_chars )
     character (LEN=5000000) :: string
     integer :: num_chars
   end subroutine count_sentences
 end interface

 call get_command_argument(1,input_string)
 
 open(unit=5,status="old",access="direct",form="unformatted",recl=1,&
  file=input_string)
  found = .false.

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
!loop to count the total number of sentences
! do i=0,(filesize-1)
!   print *, long_string(i)
! end do


 !print *, long_string
! print *, "Number of sentences: ", num_sentences
end program reader

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!subroutine to count the number of characters and fill a character 
!string with the words from the text file
subroutine read_file( string, i_string, char_counter, sentence_counter )
  character (LEN=*) :: string
  integer :: char_counter
  integer :: sentence_counter
  character (LEN=*) :: i_string
  character (LEN=1) :: input
  logical :: found


  open(unit=5,status="old",access="direct",form="unformatted",recl=1,&
  file=i_string)
  found = .false.  

  counter=1
  100 read (5,rec=char_counter,err=200) input
    string(char_counter:char_counter) = input
 !   if (is_sentence(input))then
 !   sentence_counter=sentence_counter+1
 !   endif 
    char_counter=char_counter+1
    goto 100
  200 continue
  counter=counter-1
  close (5)
end subroutine read_file

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

subroutine count_sentences ( string, num_chars )
  character (LEN=*) :: string
  integer :: num_chars
end subroutine count_sentences
