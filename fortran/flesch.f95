program reader
 implicit none
 character (LEN=5000000) :: long_string, new_long_string
 character (LEN=100) :: input_string 
 character (LEN=50) :: temp_string
 character (LEN = 50), dimension(5000000) :: tokenized_words
 !character (LEN = 50), dimension(5000000) ::
 integer :: char_counter, sentence_counter, space_counter, pos1 = 1, pos2,&
            ascii, i, n=0
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
 end interface

 
 !read in the input file name form the command line
 !i.e. a.out /pub/pounds/CSC330/translations/KJV.txt
 call get_command_argument(1,input_string)
 
 !open our file
 open(unit=5,status="old",access="direct",form="unformatted",recl=1,&
  file=input_string)

  char_counter=1
  100 read (5,rec=char_counter,err=200) input
    long_string(char_counter:char_counter) = input
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

 !do i=1,char_counter, 1
 !input = long_string(i:i)
 !if (input .ne. " ") then
  ! do j=1, index(input," "), 1
  ! ascii = iachar(input)
 !  print *, input
 !  if (.not. is_number(ascii))then
 ! temp_string 
 ! new_long_string(i:i) = input
 !  endif
 !  end do
 !end do

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
   n = n+1
   tokenized_words(n) = long_string(pos1:pos1+pos2-2)
   pos1 = pos2+pos1
 end do

 print *, n

 do i = 1, n
        print*,tokenized_words(i)
 end do
 !print *, tokenized_words
 !tokenize the long_string
 !print *, new_long_string
 !print *, input_string
 !print *, "Read ", char_counter, " characters."
 !print *, "Number of Sentences: ", sentence_counter
 !print *, "Number of words: ", space_counter+1
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
