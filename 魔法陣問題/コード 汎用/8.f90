program magic_square_f90
  implicit none
  integer, parameter :: dp = kind(1.0d0)
  integer :: n, magic
  integer :: i
  integer, allocatable :: sq(:), row(:), col(:)
  logical, allocatable :: used(:)
  integer(kind=8) :: count
  real(dp) :: t1, t2
  character(len=32) :: arg
  integer :: diag, adiag
  integer :: pos

  ! --- 引数取得 ---
  call get_command_argument(1, arg)
  if (len_trim(arg) == 0) then
     n = 4
  else
     read(arg, *) n
  end if

  magic = n * (n * n + 1) / 2

  allocate(sq(n*n))
  allocate(used(n*n))
  allocate(row(n))
  allocate(col(n))

  used = .false.
  row  = 0
  col  = 0
  count = 0_8
  diag  = 0
  adiag = 0

  call cpu_time(t1)

  pos = 1
  call search(pos, n, magic, sq, used, row, col, diag, adiag, count)

  call cpu_time(t2)

  write(*,'("N=",I0," Count=",I0," Time=",F10.6," sec")') n, count, t2 - t1

  deallocate(sq, used, row, col)

contains

  recursive subroutine search(pos, n, magic, sq, used, row, col, diag, adiag, count)
    implicit none
    integer, intent(in) :: pos, n, magic
    integer, intent(inout) :: sq(:), row(:), col(:)
    logical, intent(inout) :: used(:)
    integer, intent(inout) :: diag, adiag
    integer(kind=8), intent(inout) :: count

    integer :: r, c, v, need
    integer :: maxv
    logical :: forced

    maxv = size(used)

    if (pos > n * n) then
       count = count + 1_8
       return
    end if

    r = (pos - 1) / n + 1
    c = mod(pos - 1, n) + 1

    forced = .false.
    v = -1

    ! ---- 強制値 ----
    if (c == n) then
       need = magic - row(r)
       if (need < 1 .or. need > maxv) return
       if (used(need)) return
       v = need
       forced = .true.

    else if (r == n) then
       need = magic - col(c)
       if (need < 1 .or. need > maxv) return
       if (used(need)) return
       v = need
       forced = .true.

    else if (r == c .and. r == n) then
       need = magic - diag
       if (need < 1 .or. need > maxv) return
       if (used(need)) return
       v = need
       forced = .true.

    else if (r + c == n + 1 .and. r == n) then
       need = magic - adiag
       if (need < 1 .or. need > maxv) return
       if (used(need)) return
       v = need
       forced = .true.
    end if

    if (forced) then
       call try_value(v, pos, n, magic, sq, used, row, col, diag, adiag, count)
    else
       do v = 1, maxv
          if (.not. used(v)) then
             call try_value(v, pos, n, magic, sq, used, row, col, diag, adiag, count)
          end if
       end do
    end if

  end subroutine search


  subroutine try_value(v, pos, n, magic, sq, used, row, col, diag, adiag, count)
    implicit none
    integer, intent(in) :: v, pos, n, magic
    integer, intent(inout) :: sq(:), row(:), col(:)
    logical, intent(inout) :: used(:)
    integer, intent(inout) :: diag, adiag
    integer(kind=8), intent(inout) :: count

    integer :: r, c

    r = (pos - 1) / n + 1
    c = mod(pos - 1, n) + 1

    if (row(r) + v > magic) return
    if (col(c) + v > magic) return
    if (r == c .and. diag + v > magic) return
    if (r + c == n + 1 .and. adiag + v > magic) return

    sq(pos) = v
    used(v) = .true.
    row(r) = row(r) + v
    col(c) = col(c) + v
    if (r == c) diag = diag + v
    if (r + c == n + 1) adiag = adiag + v

    call search(pos + 1, n, magic, sq, used, row, col, diag, adiag, count)

    used(v) = .false.
    row(r) = row(r) - v
    col(c) = col(c) - v
    if (r == c) diag = diag - v
    if (r + c == n + 1) adiag = adiag - v

  end subroutine try_value

end program magic_square_f90
