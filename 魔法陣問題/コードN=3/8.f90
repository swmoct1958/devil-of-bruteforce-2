program magic_generic_fast
    implicit none
    integer :: n, target, found_count
    integer, allocatable :: board(:)
    logical, allocatable :: used(:)
    real :: t1, t2

    n = 3
    target = n * (n**2 + 1) / 2
    allocate(board(n*n), used(n*n+1))
    board = 0; used = .false.; found_count = 0

    call cpu_time(t1)
    call solve(1, n, target, board, used, found_count)
    call cpu_time(t2)

    print *, "N=", n, " Count:", found_count, " Time:", t2 - t1, "s"
contains
    recursive subroutine solve(p, n, target, board, used, count)
        integer, intent(in) :: p, n, target
        integer, intent(inout) :: board(n*n), count
        logical, intent(inout) :: used(n*n+1)
        integer :: v, i, s

        if (p > n*n) then
            if (sum([(board(i*n+i+1), i=0, n-1)]) == target .and. &
                sum([(board(i*n+(n-i)), i=0, n-1)]) == target) count = count + 1
            return
        end if

        do v = 1, n*n
            if (.not. used(v)) then
                board(p) = v
                if (mod(p, n) == 0) then
                    if (sum(board(p-n+1:p)) /= target) cycle
                end if
                if (p > n*(n-1)) then
                    s = 0
                    do i = 0, n-1
                        s = s + board(mod(p-1, n) + 1 + i*n)
                    end do
                    if (s /= target) cycle
                end if
                used(v) = .true.
                call solve(p + 1, n, target, board, used, count)
                used(v) = .false.
            end if
        end do
    end subroutine solve
end program