
module hiker_class
  implicit none
  private
  public :: hiker_answer

contains

  function hiker_answer(this) result(answer)
    type(hiker), intent(in) :: this
    integer :: answer
    answer = 6 * 9
  end function hiker_answer

end module hiker_class