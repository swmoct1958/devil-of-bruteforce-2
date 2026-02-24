program eight
  implicit none
  integer :: n, i, j, ios, unit
  integer, allocatable :: adj(:,:)
  logical, allocatable :: visited(:)
  integer(8) :: counter
  character(len=256) :: filename
  character(len=1024) :: line
  integer :: start_count, end_count, rate
  real(8) :: ms

  call get_command_argument(1, filename)
  if (len_trim(filename) == 0) then
     print *, 'Usage: 8 <graphfile>'
     stop
  end if

  ! ---- 1. 行数を数える ----
  open(newunit=unit, file=trim(filename), status='old', action='read', iostat=ios)
  if (ios /= 0) then
     print *, 'Cannot open file: ', trim(filename)
     stop
  end if

  n = 0
  do
     read(unit, '(A)', iostat=ios) line
     if (ios /= 0) exit
     n = n + 1
  end do
  rewind(unit)

  allocate(adj(n,n), visited(n))

  ! ---- 2. 行単位で読み込む（重要）----
  do i = 1, n
     read(unit, '(A)', iostat=ios) line
     if (ios /= 0) then
        print *, 'Read error'
        stop
     end if
     read(line, *) (adj(i,j), j=1,n)
  end do
  close(unit)

  visited = .false.
  counter = 0_8

  call system_clock(start_count, rate)
  call dfs(1, adj, visited, n, counter)
  call system_clock(end_count)

  ms = real(end_count - start_count, kind=8) * 1000.0d0 / real(rate, kind=8)

  print '(A,1X,A)', 'file =', trim(filename)
  print '(A,1X,I0)', 'N =', n
  print '(A,1X,I0)', 'counter =', counter
  print '(A,1X,F0.4)', 'time =', ms

contains

  recursive subroutine dfs(v, adj, visited, n, counter)
    implicit none
    integer, intent(in) :: v, n
    integer, intent(in) :: adj(n,n)
    logical, intent(inout) :: visited(n)
    integer(8), intent(inout) :: counter
    integer :: i

    visited(v) = .true.
    counter = counter + 1_8

    do i = 1, n
       if (adj(v,i) == 1 .and. .not. visited(i)) then
          call dfs(i, adj, visited, n, counter)
       end if
    end do

    visited(v) = .false.
  end subroutine dfs

end program eight
