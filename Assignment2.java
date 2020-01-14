import java.sql.*;

public class Assignment2 {

    // A connection to the databASe  
    Connection connection;

    // Statement to run queries
    Statement sql;

    // Prepared Statement
    PreparedStatement ps;

    // Resultset for the query
    ResultSet rs;

    //CONSTRUCTOR
    Assignment2() {
        try {
            // Load JDBC driver
            Class.forName("org.postgresql.Driver");
        } catch (ClassNotFoundException e) {
//            System.out.println("WHERE is your PostgreSQL JDBC Driver? Include in your library path!");
//            e.printStackTrace();
            return;

        }
    }

    //Using the input parameters, establish a connection to be used for this session. Returns true if connection is sucessful
    public boolean connectDB(String URL, String username, String pASsword) {
        try {

            //Make the connection to the databASe, ****** but replace <dbname>, <username>, <pASsword> with your credentials ******
//            System.out.println("*** PleASe make sure to replace 'dbname', 'username' AND 'pASsword' with your credentials in the jdbc connection string!!!");
            this.connection = DriverManager.getConnection(URL, username, pASsword);

            if (connection != null) {
                return true;
            } else {
                return false;
            }

        } catch (SQLException e) {
//            System.out.println("Connection Failed! Check output console");
//            e.printStackTrace();
            return false;
        }

    }

    //Closes the connection. Returns true if closure wAS sucessful
    public boolean disconnectDB() {
        try {
            connection.close();
            return connection.isClosed();
        } catch (SQLException e) {
//            System.out.println(e.getMessage());
            return false;
        }

    }

    public boolean insertPlayer(int pid, String pname, int globalRank, int cid) {
        boolean result = false;
        try {
            ps = connection.prepareStatement("INSERT INTO player VALUES(?,?,?,? )");
            ps.setInt(1, pid);
            ps.setString(2, pname);
            ps.setInt(3, globalRank);
            ps.setInt(4, cid);

            if(ps.executeUpdate()>0){
                result = true;
            }
        } catch (SQLException e) {
//            e.printStackTrace();

        }finally {
            try{
                if(ps!=null) ps.close();
            }catch(Exception e){

            }
        }
        return result;
    }

    public int getChampions(int pid) {
        int result = 0;
        try {
            ps = connection.prepareStatement("SELECT COUNT(*) AS numChamp FROM champion WHERE pid= ?");
            ps.setInt(1, pid);
            rs = ps.executeQuery();

            while (rs.next()){
                result = rs.getInt(1);
                 break;
            }
//    		 retrun int?

        } catch (SQLException e) {
//            e.printStackTrace();
        }finally {
            try{
                if(ps!=null) ps.close();
            }catch (Exception e){

            }
        }
        return result;
    }

    public String getCourtInfo(int courtid) {
        String result = "";
        try {
            ps = connection.prepareStatement("SELECT courtid,courtname,capacity,tname FROM court,tournament WHERE courtid=? AND court.tid = tournament.tid");
            ps.setInt(1, courtid);
            rs = ps.executeQuery();

            while (rs.next()){
                String r1 = rs.getString(1);
                String r2 = rs.getString(2);
                String r3 = rs.getString(3);
                String r4 = rs.getString(4);
                if (r1 == null) {
                    break;
                }
                result = "courtid:" + r1 + "courtname:" + r2 + "capacity:" + r3 + "tournamentname:" + r4;
                break;
            }


        } catch (SQLException e) {
//            e.printStackTrace();

        }finally {
            try{
                if(ps!=null) ps.close();
            }catch (Exception e){

            }
        }

        return result;
    }

    public boolean chgRecord(int pid, int year, int wins, int losses) {
        boolean result = false;
        try {
            ps = connection.prepareStatement("UPDATE record SET wins=?,losses=? WHERE pid = ? AND year = ?");
            ps.setInt(1, wins);
            ps.setInt(2, losses);
            ps.setInt(3, pid);
            ps.setInt(4, year);
//    		excute update

            if(ps.executeUpdate()>0){
                result = true;
            }

        } catch (SQLException e) {
//            e.printStackTrace();

        }finally {
            try{
                if(ps!=null) ps.close();
            }catch(Exception e){

            }
        }

        return result;
    }

    public boolean deleteMatcBetween(int p1id, int p2id) {
        boolean result = false;
        try {
            ps = connection.prepareStatement("DELETE FROM event WHERE winid IN (?,?) AND lossid IN (?,?)");
            ps.setInt(1, p1id);
            ps.setInt(2, p2id);
            ps.setInt(3, p1id);
            ps.setInt(4, p2id);
//        	rs = ps.executeQuery();
//			excute delete
            if(ps.executeUpdate()>0)
                result = true;
//	   		 rs.close();

        } catch (SQLException e) {
            e.printStackTrace();
        }

        finally {
            try{
                if(ps!=null)
                    ps.close();
            }catch(Exception e){

            }
        }
        return result;
    }

    public String listPlayerRanking() {

        String res = "";
        try {
            sql = connection.createStatement();
            rs = sql.executeQuery("SELECT pname,globalrank,cid FROM player ORDER BY globalrank");

            if (rs != null) {
                while (rs.next()) {
                    if (rs.getString(3) == null) {
                        res += "";
                    } else {
                        res += rs.getString(1) + ":" + rs.getString(2) + "\n";
                    }
                }
            }

        } catch (SQLException e) {
//            e.printStackTrace();
            return "";
        }finally {
            try{
                if(rs!=null) rs.close();
                if(sql!=null) sql.close();
            }
            catch (Exception e){

            }
        }

        return res;
    }

    public int findTriCircle() {
    	int result=0;
        try{
            sql = connection.createStatement();
            rs = sql.executeQuery("SELECT count(*)/3 FROM\n" + 
            		"(SELECT e1.winid AS pa,e2.winid AS pb,e3.winid AS pc\n" + 
            		"FROM event e1,event e2,event e3\n" + 
            		"WHERE e1.winid = e2.lossid AND e2.winid = e3.lossid AND e3.winid = e1.lossid) AS t1");
            while(rs.next()) {
            	result = rs.getInt(1);
            }

        }
        catch (SQLException e) {
//            e.printStackTrace();
            return 0;
        }
        finally {
        	try {
        		if(rs!=null) rs.close();
        		if(sql!=null)sql.close();
        	}catch(Exception e) {
        		
        	}
        }
        return result;
    }

    public boolean updateDB() {
        boolean result = false;
        try {
            sql = connection.createStatement();
            String sql1 = "CREATE TABLE championPlayers ( pid INTEGER,pname VARCHAR,nchampions INTEGER)";
            sql.executeUpdate(sql1);
            rs = sql.executeQuery("SELECT champion.pid,pname,count(*)AS nchampions FROM champion,player WHERE " +
                    "champion.pid = player.pid GROUP BY champion.pid,pname ORDER BY pid");
            if (rs != null) {
                while (rs.next()) {
                    ps = connection.prepareStatement("INSERT INTO championPlayers VALUES(?,?,?)");
                    ps.setInt(1, Integer.parseInt(rs.getString(1)));
                    ps.setString(2, rs.getString(2));
                    ps.setInt(3, Integer.parseInt(rs.getString(3)));
                    if(ps.executeUpdate()>0)
                        result = true;
                }
            }
//// check updated successfully ??
//            if(sql.getUpdateCount()>0){
//                return true;
//            }else{return false;}

        } catch (SQLException e) {
//            e.printStackTrace();

        }finally {
            try{
                if(rs!=null) rs.close();
                if(ps!=null) ps.close();
                if(sql!=null) sql.close();

            }catch (Exception e){

            }
        }
        return result;
    }

}
