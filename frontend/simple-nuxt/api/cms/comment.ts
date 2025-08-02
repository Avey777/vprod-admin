import type { BaseDataResp, BaseListResp } from "../base/model/baseModel";
import type { CommentInfo, GetCommentListReq } from "./model/commentModel";

export enum Api {
  GetCommentList = "/cms-api/article_comment/article",
  AddComment = "/cms-api/article_comment/add",
}

export const getCommentList = (params: GetCommentListReq) =>
  xFetch<BaseDataResp<BaseListResp<CommentInfo>>>(Api.GetCommentList, {
    body: params,
    method: "POST",
  });

export const addComment = (params: CommentInfo) =>
  xFetch<BaseDataResp<BaseListResp<BaseDataResp<string>>>>(Api.AddComment, {
    body: params,
    method: "POST",
  });
