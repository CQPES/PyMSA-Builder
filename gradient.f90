module gradient
  implicit none

contains
  function demsav(drdx,c,m,p,flag) result(grad)
    implicit none
    real*8,dimension(9,3)::drdx
    real*8,dimension(0:9)::c
    real*8,dimension(0:3)::m
    real*8,dimension(0:9)::p
    real*8::grad
    integer::flag
    ! ::::::::::::::::::::
    real*8,dimension(0:9)::dp

    call dbemsav(drdx,dp,m,p,flag)
    grad = dot_product(dp,c)

    return
  end function demsav

  subroutine dbemsav(drdx,dp,m,p,flag)
    implicit none
    real*8,dimension(9,3),intent(in)::drdx
    real*8,dimension(0:9),intent(out)::dp
    real*8,dimension(0:3),intent(in)::m
    real*8,dimension(0:9),intent(in)::p
    integer::flag
    ! ::::::::::::::::::::
    real*8,dimension(0:3)::dm

    call devmono(drdx,dm,m,flag)
    call devpoly(dm,p,dp)

    return
  end subroutine dbemsav

  subroutine devmono(drdx,dm,m,flag)
    implicit none
    real*8,dimension(9,3),intent(in)::drdx
    real*8,dimension(0:3),intent(out)::dm
    real*8,dimension(0:3),intent(in)::m
    integer::flag
    !::::::::::::::::::::
    real*8::a

    a = 1.0d0

    dm(0) = 0.0D0
    dm(1) = -m(1)/a*drdx(flag,3)
    dm(2) = -m(2)/a*drdx(flag,2)
    dm(3) = -m(3)/a*drdx(flag,1)

    return
  end subroutine devmono

  subroutine devpoly(dm,p,dp)
    implicit none
    real*8,dimension(0:3),intent(in)::dm
    real*8,dimension(0:9),intent(in)::p
    real*8,dimension(0:9),intent(out)::dp
    !::::::::::::::::::::

    dp(0) = dm(0)
    dp(1) = dm(1)
    dp(2) = dm(2)
    dp(3) = dm(3)
    dp(4) = dp(1)*p(2) + p(1)*dp(2)
    dp(5) = dp(1)*p(3) + p(1)*dp(3)
    dp(6) = dp(2)*p(3) + p(2)*dp(3)
    dp(7) = dp(1)*p(1) + p(1)*dp(1)
    dp(8) = dp(2)*p(2) + p(2)*dp(2)
    dp(9) = dp(3)*p(3) + p(3)*dp(3)

    return
  end subroutine devpoly

end module gradient
