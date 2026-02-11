program magic4_fortran
    implicit none
    integer :: board(0:15)
    integer(4) :: used
    integer(8) :: total_count
    real :: start_time, end_time

    total_count = 0
    used = 0
    board = 0

    print *, "Fortran n=4 Search Start..."
    call cpu_time(start_time)

    call solve(0, board, used, total_count)

    call cpu_time(end_time)
    print "(A, I0, A)", "Count: ", total_count, " (7040)"
    print "(A, F10.2, A)", "Time: ", (end_time - start_time) * 1000.0, " ms"

contains

    recursive subroutine solve(pos, board, used, total_count)
        integer, intent(in) :: pos
        integer, intent(inout) :: board(0:15)
        integer(4), intent(inout) :: used
        integer(8), intent(inout) :: total_count
        integer :: v, v12, v13, v14, v15
        integer, parameter :: S = 34

        if (pos == 3) then
            v = S - (board(0) + board(1) + board(2))
            if (v >= 1 .and. v <= 16 .and. .not. btest(used, v)) then
                board(3) = v
                used = ibset(used, v)
                call solve(4, board, used, total_count)
                used = ibclr(used, v)
            end if
            return
        end if

        if (pos == 7) then
            v = S - (board(4) + board(5) + board(6))
            if (v >= 1 .and. v <= 16 .and. .not. btest(used, v)) then
                board(7) = v
                used = ibset(used, v)
                call solve(8, board, used, total_count)
                used = ibclr(used, v)
            end if
            return
        end if

        if (pos == 11) then
            v = S - (board(8) + board(9) + board(10))
            if (v >= 1 .and. v <= 16 .and. .not. btest(used, v)) then
                board(11) = v
                used = ibset(used, v)
                call solve(12, board, used, total_count)
                used = ibclr(used, v)
            end if
            return
        end if

        if (pos == 12) then
            v12 = S - (board(0) + board(4) + board(8))
            if (v12 < 1 .or. v12 > 16 .or. btest(used, v12)) return
            v13 = S - (board(1) + board(5) + board(9))
            if (v13 < 1 .or. v13 > 16 .or. v13 == v12 .or. btest(used, v13)) return
            v14 = S - (board(2) + board(6) + board(10))
            if (v14 < 1 .or. v14 > 16 .or. v14 == v12 .or. v14 == v13 .or. btest(used, v14)) return
            v15 = S - (board(3) + board(7) + board(11))
            if (v15 < 1 .or. v15 > 16 .or. v15 == v12 .or. v15 == v13 .or. v15 == v14 .or. btest(used, v15)) return

            if (v12 + v13 + v14 + v15 == S .and. &
                board(0) + board(5) + board(10) + v15 == S .and. &
                board(3) + board(6) + board(9) + v12 == S) then
                total_count = total_count + 1
            end if
            return
        end if

        do v = 1, 16
            if (.not. btest(used, v)) then
                used = ibset(used, v)
                board(pos) = v
                call solve(pos + 1, board, used, total_count)
                used = ibclr(used, v)
            end if
        end do
    end subroutine solve

end program magic4_fortran
