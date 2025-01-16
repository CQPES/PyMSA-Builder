program main
    use basis
    implicit none

    integer, parameter :: num_atoms = 5
    real(kind=8) :: xyz(3, num_atoms)

    integer :: len_r = num_atoms * (num_atoms - 1) / 2
    real(kind=8), allocatable :: r(:)
    real(kind=8), allocatable :: x(:)
    real(kind=8) :: p(83)

    integer :: i, j, k

    xyz(:, 1) = (/ 0.00000000, -0.00000000,  1.07000000/)  ! H
    xyz(:, 2) = (/-0.00000000, -1.00880567, -0.35666667/)  ! H
    xyz(:, 3) = (/-0.87365134,  0.50440284, -0.35666667/)  ! H
    xyz(:, 4) = (/ 0.87365134,  0.50440284, -0.35666667/)  ! H
    xyz(:, 5) = (/-0.00000000, -0.00000000, -0.00000000/)  ! C

    do i = 1, num_atoms
        print *, "atom ", i, xyz(:, i)
    end do

    print *, ""

    allocate(r(len_r))
    allocate(x(len_r))

    k = 1
    do i = 1, (num_atoms - 1)
        do j = (i + 1), num_atoms
            r(k) = sqrt(dot_product(xyz(:, i) - xyz(:, j), xyz(:, i) - xyz(:, j)))
            x(k) = exp(-1.0d0 * r(k) / 1.0d0)
            k = k + 1
        end do
    end do

    do i = 1, len_r
        print *, "r(", i, ") = ", r(i)
    end do

    print *, ""

    do i = 1, len_r
        print *, "x(", i, ") = ", x(i)
    end do

    print *, ""

    call bemsav(x, p)

    do i = 1, size(p, 1)
        print *, "p(", i, ") = ", p(i)
    end do

    print *, ""

end program main