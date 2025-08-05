package src.business.user.model;

public class UserModel {
    private int id;
    private String account_number;
    private String name;
    private String address;
    private String telephone;
    private String email;
    private String user_type;


    public UserModel() {
    }

    public UserModel(int id, String account_number, String name, String address, String telephone, String email, String user_type) {
        this.id = id;
        this.account_number = account_number;
        this.name = name;
        this.address = address;
        this.telephone = telephone;
        this.email = email;
        this.user_type = user_type;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getAccount_number() {
        return account_number;
    }

    public void setAccount_number(String account_number) {
        this.account_number = account_number;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getTelephone() {
        return telephone;
    }

    public void setTelephone(String telephone) {
        this.telephone = telephone;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getUser_type() {
        return user_type;
    }

    public void setUser_type(String user_type) {
        this.user_type = user_type;
    }
}
