
module hiker_class

  implicit none
  private
  public :: hiker, hiker_answer

  type hiker
  end type hiker

contains

  function hiker_answer(this) result(answer)
    type(hiker), intent(in) :: this
    integer :: answer
    answer = 6 * 7
  end function hiker_answer

end module hiker_class