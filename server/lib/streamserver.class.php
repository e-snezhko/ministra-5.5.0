<?php

use Stalker\Lib\Core\Mysql;
use Stalker\Lib\Core\Config;

class StreamServer
{

    public static function getById($id){
        return Mysql::getInstance()
            ->from('streaming_servers')
            ->where(array('id' => intval($id)))
            ->use_caching(array('streaming_servers.id='.intval($id)))
            ->get()
            ->first();
    }

    public static function getAllActive($with_load = false){
        $streamers = Mysql::getInstance()
            ->from('streaming_servers')
            ->where(array('status' => 1))
            ->orderby('name')
            ->get()
            ->all();

        if ($with_load){
            return self::countStats($streamers);
        }else{
            return $streamers;
        }
    }

    public static function getAll(){
        return Mysql::getInstance()
            ->from('streaming_servers')
            ->orderby('name')
            ->get()
            ->all();
    }

    public static function getIdMap(){
        $all_servers = self::getAll();

        $map = array();

        foreach ($all_servers as $server){
            $map[$server['id']] = $server;
        }

        return $map;
    }

    public static function getForLink($link_id){

        $streamer_ids = self::getGoodStreamersIdsForLink($link_id);

        if (empty($streamer_ids)){
            throw new EmptyStreamList();
        }

        $streamers = Mysql::getInstance()
            ->from('streaming_servers')
            ->where(array('status' => 1))
            ->in('id', $streamer_ids)
            ->get()
            ->all();

        if (empty($streamers)){
            throw new EmptyStreamList();
        }

        $streamers = self::filterByEntity($streamers);

        if (empty($streamers)){
            throw new NotAvailableForZone();
        }

        $streamers = self::countStats($streamers, true);

        return $streamers;
    }


    public static function isIpInNets($ip, $nets){

        if (!is_array($nets)){
            $nets = array($nets);
        }

        foreach ($nets as $net){
            if (self::isIpInNet($ip, $net)){
                return true;
            }
        }

        return false;
    }

    private static function isIpInNet($ip, $CIDR){

        if (strpos($CIDR, '/') === false){
            return $ip == $CIDR;
        }

        list ($net, $mask) = explode('/', $CIDR);

        $ip_net  = ip2long($net);
        $ip_mask = ~((1 << (32 - $mask)) - 1);

        $ip_ip = ip2long($ip);

        $ip_ip_net = $ip_ip & $ip_mask;

        return ($ip_ip_net == $ip_net);
    }

    private static function filterByEntity($streamers){

        $country_id = User::getCountryId();
        $user = User::getInstance();
        $user_ip = $user->getIp();

        $streamer_ids = array();

        $streamers = array_map(function($streamer) use (&$streamer_ids){

            if ($streamer['stream_zone'] != 0){
                $stream_zone = Mysql::getInstance()
                    ->from('stream_zones')
                    ->where(array('id' => $streamer['stream_zone']))
                    ->get()
                    ->first();
            }else{
                $stream_zone = null;
            }

            if ($stream_zone['type'] == 'ip'){
                $streamer['ips'] = StreamServer::getIPs($streamer['stream_zone']);
            }else{
                $streamer['countries'] = StreamServer::getCountries($streamer['stream_zone']);
            }

            $streamer_ids[] = $streamer['id'];

            return $streamer;
        }, $streamers);

        $filtered_streamers = array_filter($streamers, function($streamer) use ($country_id, $user_ip){
            return $streamer['stream_zone'] == 0
            || isset($streamer['countries']) && array_search($country_id, $streamer['countries']) !== false
            || isset($streamer['ips']) && StreamServer::isIpInNets($user_ip, $streamer['ips']);
        });

        if (empty($filtered_streamers)){
            $filtered_streamers = Mysql::getInstance()
                ->select('streaming_servers.*, stream_zones.default_zone')
                ->from('streaming_servers')
                ->join('stream_zones', 'stream_zone', 'stream_zones.id', 'LEFT')
                ->where(array('default_zone' => 1))
                ->in('streaming_servers.id', $streamer_ids)
                ->get()
                ->all();
        }

        return $filtered_streamers;
    }

    public static function getCountries($zone_id){
        return Mysql::getInstance()->from('countries_in_zone')->where(array('zone_id' => $zone_id))->get()->all('country_id');
    }

    public static function getIPs($zone_id){
        return Mysql::getInstance()->from('ips_in_zone')->where(array('zone_id' => $zone_id))->get()->all('ip');
    }

    private static function countStats($streamers, $sort_by_load = false){

        $streamers = array_map(function($streamer){

            $streamer['sessions'] = StreamServer::getStreamerSessions($streamer['id']);
            $streamer['load']     = StreamServer::getLoad($streamer['id'], $streamer['sessions']);

            return $streamer;
        }, $streamers);

        if ($sort_by_load){
            $streamers = self::sortByLoad($streamers);
        }

        return $streamers;
    }

    public static function getGoodStreamersIdsForLink($link_id){

        $link = Itv::getLinkById($link_id);

        if (empty($link)){
            return false;
        }

        $ch_link_on_streamer = Mysql::getInstance()
            ->from('ch_link_on_streamer')
            ->where(array('link_id' => $link_id))
            ->get()
            ->all();

        if ($link['enable_monitoring'] && $link['enable_balancer_monitoring']){
            $ch_link_on_streamer = array_values(array_filter($ch_link_on_streamer, function($link_on_streamer){
                return $link_on_streamer['monitoring_status'] == 1;
            }));
        }

        $ch_link_on_streamer = array_map(function($link_on_streamer){
            return $link_on_streamer['streamer_id'];
        }, $ch_link_on_streamer);

        return $ch_link_on_streamer;
    }

    public static function getStreamersIdMapForLink($link_id){

        $streamers = Mysql::getInstance()
            ->from('ch_link_on_streamer')
            ->where(array('link_id' => $link_id))
            ->get()
            ->all();

        $map = array();

        foreach ($streamers as $streamer){
            $map[$streamer['streamer_id']] = $streamer;
        }

        return $map;
    }

    public static function getLoad($streamer_id, $sessions = null){

        $streamer = self::getById($streamer_id);

        if ($streamer['max_sessions'] > 0){

            if ($sessions === null){
                $sessions = self::getStreamerSessions($streamer_id);
            }

            return $sessions / $streamer['max_sessions'];
        }
        return 1;
    }

    public static function getStreamerSessions($streamer_id){

        $sessions = Mysql::getInstance()->count()->from('users')
            ->where(array(
                'now_playing_streamer_id' => $streamer_id,
                'now_playing_type' => 1,
                'keep_alive>' => date(Mysql::DATETIME_FORMAT, time() - Config::get('watchdog_timeout')*2)
            ))
            ->get()
            ->counter();

        return $sessions;
    }

    private static function sortByLoad($streamers){

        if (!empty($streamers)){

            foreach ($streamers as $name => $streamer) {
                $load[$name] = $streamer['load'];
            }

            array_multisort($load, SORT_ASC, SORT_NUMERIC, $streamers);
        }

        return $streamers;
    }
}

class EmptyStreamList extends Exception
{
    protected $code = 'nothing_to_play';
}

class NotAvailableForZone extends Exception
{
    protected $code = 'not_available_for_zone';
}