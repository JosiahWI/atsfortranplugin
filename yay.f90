!> An ATS plugin written in Fortran.

module yay
  use, intrinsic :: iso_c_binding
  implicit none    

  private
  public :: init

  type, bind(c) :: reg_info_type
    character(kind = c_char) :: plugin_name
    character(kind = c_char) :: vendor
    character(kind = c_char) :: support_email
  end type

  interface

    function ts_plugin_register() bind(C, name='_Z16TSPluginRegisterPK24TSPluginRegistrationInfo')
      use, intrinsic :: iso_c_binding

      integer(kind = c_int) :: ts_plugin_register
    end function ts_plugin_register

  end interface

  character(len = 15) :: plugin_name = 'Fortran Plugin' // c_null_char
  character(len = 27) :: vendor = 'Apache Software Foundation' // c_null_char
  character(len = 29) :: support_email = 'dev@trafficserver.apache.org' // c_null_char

contains


  !> Initialize the plugin.
  function init() result(success) bind(C, name='TSPluginInit')
    integer(kind = c_int) :: success
   
    call register()
    success = 1
  end function init

  subroutine register()
    integer(kind = c_int) :: success
    type(reg_info_type) :: reginfo

    character(len = :), pointer :: plugin_name_ptr
    character(len = :), pointer :: vendor_ptr
    character(len = :), pointer :: support_email_ptr

    plugin_name_ptr = plugin_name
    vendor_ptr = vendor
    support_email_ptr = support_email

    reginfo%plugin_name = plugin_name_ptr
    reginfo%vendor = vendor_ptr
    reginfo%support_email = support_email_ptr

    success = ts_plugin_register()
  end subroutine register

end module yay
