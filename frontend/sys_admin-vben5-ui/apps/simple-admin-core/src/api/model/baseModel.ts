export interface BaseListReq {
  page: number;
  pageSize: number;
}

export interface BaseListResp<T> {
  result: T[];
  total: number;
}

export interface BaseDataResp<T> {
  code: number;
  msg: string;
  result: T;
}

export interface BaseResp {
  code?: number;
  msg: string;
}

export interface BaseIDReq {
  id?: number;
}

export interface BaseIDsReq {
  ids: number[];
}

export interface BaseUUIDReq {
  id: string;
}

export interface BaseUUIDsReq {
  ids: string[];
}
