program nqueens_qpc
  use iso_c_binding
  implicit none

  interface
     subroutine QueryPerformanceCounter(count) bind(C, name="QueryPerformanceCounter")
       import :: c_long_long
       integer(c_long_long), intent(out) :: count
     end subroutine

     subroutine QueryPerformanceFrequency(freq) bind(C, name="QueryPerformanceFrequency")
       import :: c_long_long
       integer(c_long_long), intent(out) :: freq
     end subroutine
  end interface

  integer :: n
  integer :: cols, d1, d2
  integer(kind=8) :: count
  integer(c_long_long) :: t1, t2, freq
  character(len=16) :: arg

  call get_command_argument(1, arg)
  if (len_trim(arg) == 0) then
     n = 14
  else
     read(arg, *) n
  end if

  count = 0_8
  cols = 0
  d1 = 0
  d2 = 0

  call QueryPerformanceFrequency(freq)
  call QueryPerformanceCounter(t1)

  call dfs(0, n, cols, d1, d2, count)

  call QueryPerformanceCounter(t2)

  print '(A,I0,A,I0,A,F10.6,A)', &
        'N=', n, ' Count=', count, ' Time=', real(t2 - t1) / real(freq), ' sec'

contains

  recursive subroutine dfs(row, n, cols, d1, d2, count)
    implicit none
    integer, intent(in) :: row, n
    integer, intent(in) :: cols, d1, d2
    integer(kind=8), intent(inout) :: count
    integer :: mask, avail, p, cols2, d12, d22

    if (row == n) then
       count = count + 1_8
       return
    end if

    mask = ishft(1, n) - 1
    avail = iand(mask, not(ior(ior(cols, d1), d2)))

    do while (avail /= 0)
       p = iand(avail, -avail)
       avail = ieor(avail, p)
       cols2 = ior(cols, p)
       d12 = ishft(ior(d1, p), 1)
       d22 = ishft(ior(d2, p), -1)
       call dfs(row + 1, n, cols2, d12, d22, count)
    end do
  end subroutine dfs

end program nqueens_qpc
