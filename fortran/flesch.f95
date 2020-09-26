program reader
 character (LEN=5000000) :: long_string
 integer :: filesize
 character (LEN=50) :: input_string 

 interface
   subroutine read_file( string, i_string, counter )
     character (LEN=5000000) :: string
     character (LEN=50) :: i_string
     integer :: counter !counter represents the filesize
   end subroutine read_file
 end interface

 print *, "Enter enter file:" 
 !read *, input_string
 call get_command_argument(1,input_string)
 print *, "File"
 print *, input_string
 call read_file( long_string, input_string, filesize )
 !print *, long_string
 print *, "Read ", filesize, " characters."
end program reader

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

subroutine read_file( string, i_string, counter )
  character (LEN=*) :: string
  integer :: counter
  character (LEN=*) :: i_string
  character (LEN=1) :: input

  open(unit=5,status="old",access="direct",form="unformatted",recl=1,&
  file=i_string)

  counter=1
  100 read (5,rec=counter,err=200) input
    string(counter:counter) = input
    counter=counter+1
  goto 100
  200 continue
  counter=counter-1
  close (5)
end subroutine read_file
