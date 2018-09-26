module c_bmiheat

  use, intrinsic :: iso_c_binding
  use bmiheatf

  implicit none

  integer, parameter :: N_MODELS = 3
  type (bmi_heat), target :: model_array(N_MODELS)
  type (bmi_heat), pointer :: pmodel

contains

  ! Find the next unused model index in the array.
  function c_new() bind(c) result(model_index)
    integer (c_int) :: model_index
    integer :: i

    model_index = 0
    do i = 1, N_MODELS
       if (associated(pmodel, target=model_array(i))) then
          nullify(pmodel)
          model_index = i
       end if
    end do
    if (model_index.eq.N_MODELS) then
       model_index = -1
    else
       model_index = model_index + 1
       pmodel => model_array(model_index)
    end if
  end function c_new

  ! Initialize one model in the array, based on the input index.
  function c_initialize(model_index, config_file, n) bind(c) result(status)
    integer (c_int), intent(in), value :: model_index
    integer (c_int), intent (in), value :: n
    character (len=1, kind=c_char), intent (in) :: config_file(n)
    integer (c_int) :: i, status
    character (len=n, kind=c_char) :: config_file_

    ! Convert `config_file` from rank-1 array to scalar.
    do i = 1, n
       config_file_(i:i) = config_file(i)
    enddo

    status = model_array(model_index)%initialize(config_file_)
  end function c_initialize

  ! Clean up one model in the array.
  function c_finalize(model_index) bind(c) result(status)
    integer (c_int), intent(in), value :: model_index
    integer (c_int) :: status

    status = model_array(model_index)%finalize()
  end function c_finalize

  ! Get the component name attribute.
  function c_get_component_name(model_index, name, n) bind(c) result(status)
    integer (c_int), intent(in), value :: model_index
    integer (c_int), intent (in), value :: n
    character (len=1, kind=c_char), intent (out) :: name(n)
    integer (c_int) :: i, status
    character (len=n, kind=c_char), pointer :: name_

    ! Convert `name` from rank-1 array to scalar.
    do i = 1, n
       name_(i:i) = name(i)
    enddo

    status = model_array(model_index)%get_component_name(name_)

    ! Load the `_name` result, trimmed, back into `name` for output.
    do i = 1, len(trim(name_))
        name(i) = name_(i:i)
    enddo
  end function c_get_component_name

end module c_bmiheat