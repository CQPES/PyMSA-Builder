module basis
  implicit none

contains
  function emsav(x,c) result(v)
    implicit none
    real*8,dimension(1:3)::x
    real*8,dimension(0:9)::c
    real*8::v
    ! ::::::::::::::::::::
    real*8,dimension(0:9)::p

    call bemsav(x,p)
    v = dot_product(p,c)

    return
  end function emsav

  subroutine bemsav(x,p)
    implicit none
    real*8,dimension(1:3),intent(in)::x
    real*8,dimension(0:9),intent(out)::p
    ! ::::::::::::::::::::
    real*8,dimension(0:3)::m

    call evmono(x,m)
    call evpoly(m,p)

    return
  end subroutine bemsav

  subroutine evmono(x,m)
    implicit none
    real*8,dimension(1:3),intent(in)::x
    real*8,dimension(0:3),intent(out)::m
    !::::::::::::::::::::

    m(0) = 1.0D0
    m(1) = x(3)
    m(2) = x(2)
    m(3) = x(1)

    return
  end subroutine evmono

  subroutine evpoly(m,p)
    implicit none
    real*8,dimension(0:3),intent(in)::m
    real*8,dimension(0:9),intent(out)::p
    !::::::::::::::::::::

    p(0) = m(0)
    p(1) = m(1)
    p(2) = m(2)
    p(3) = m(3)
    p(4) = p(1)*p(2)
    p(5) = p(1)*p(3)
    p(6) = p(2)*p(3)
    p(7) = p(1)*p(1)
    p(8) = p(2)*p(2)
    p(9) = p(3)*p(3)

    return
  end subroutine evpoly

end module basis
